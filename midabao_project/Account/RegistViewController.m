//
//  RegistViewController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "RegistViewController.h"
#import "LimitTextField.h"
#import "VerifyCodeButton.h"
#import "UserInfoManager.h"

#import "SetGesturePwdVC.h"
#import "GuideSetexchangePwdVC.h"
#import "LoginNavigationVController.h"
#import "UserInfoModel.h"
#import "NSString+ExtendMethod.h"
#import "WebVC.h"
@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet LimitTextField *phone;
@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
@property (weak, nonatomic) IBOutlet LimitTextField *password;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)UserInfoModel *usermodel;

@end

@implementation RegistViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}
-(void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    if (UISCREEN_HEIGHT-height>self.myScrollview.contentSize.height+105) {
        self.myScrollview.contentSize=CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT-height+105);
        self.myScrollview.contentOffset=CGPointMake(0, 100);
    }else{
        self.myScrollview.contentOffset=CGPointMake(0, 100);
    }
}
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    if (UISCREEN_HEIGHT-height>self.myScrollview.contentSize.height+105) {
        self.myScrollview.contentSize=CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT-height-105);
    }
}
- (IBAction)seeReigstxiyiClick:(id)sender {
    WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/agreement.html"];
    web.needPopAnimation=YES;
    [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)LoginClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pwdisSeeClick:(id)sender {
    UIButton *btn=sender;
    btn.selected=!btn.selected;
    self.password.secureTextEntry=!btn.selected;
}
- (IBAction)getVerifyCodeClick:(VerifyCodeButton *)sender {
    [self.view endEditing:YES];
    if (!self.phone.success) {
        [SpringAlertView showInWindow:self.view.window message:NSLocalizedString(@"err_phone", nil)];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    
    @weakify(self)
    //获取验证码
    self.operation=[NetWorkOperation SendRequestWithMethods:@"getcode" params:@{@"phone":self.phone.text,VERIFY_CODE_TYPE_KEY:VERIFY_REGIST} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
//        NSLog(@"--code:%@",result[RESULT_DATA][@"code"]);
        [SpringAlertView showInWindow:self.view.window message:@"已发送验证码，请注意查收短信息"];
        [self.codeBtn countDown:AUTHCODE_REPEAT_INTERVAL];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (IBAction)RegistClick:(id)sender {
    [self.view endEditing:YES];
    
    if (!self.password.success  ) {
        [SpringAlertView showMessage:@"手机号码格式错误！"];
        return;
    }
    if (!self.verifyCode.success) {
        [SpringAlertView showMessage:@"验证码错误"];
        return;
    }
    if (!self.password.success) {
        [SpringAlertView showMessage:@"请设置6~16位数字或字母组合"];
        return;
    }
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"register" params:@{@"phone":self.phone.text,@"code":self.verifyCode.text,@"loginPwd":[[[NSString stringWithFormat:@"%@%@",self.password.text,APPSECRETVALUE] MD5Encryption]uppercaseString],@"codeType":VERIFY_REGIST,@"source":@"1"} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self trimParameswithDic:result[RESULT_DATA]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
-(void)trimParameswithDic:(NSDictionary *)dic{
    //报存用户信息
    [[UserInfoManager shareUserManager]updateLoginInfo:@{Key_UserID:dic[@"userId"],Key_Token:dic[@"token"]}];
    
    SetGesturePwdVC *pwdVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SetGesturePwdVC class])];
    pwdVc.type=kGesturePasswordSetting;
    [pwdVc setCompletionBlock:^(SetGesturePwdVC *vc, GesturePasswordOperationType type) {
        if (type==kGesturePasswordOperationSuccess) {//设置手势成功的时候
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:DID_OPEN_GESTURE];
            [userDefaults synchronize];//存储本地手势
            //打开TouchID
            if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
                
                [AlertViewManager showInViewController:self title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {//开启指纹解锁
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
                        [userDefaults synchronize];
                    }
                    [self showAuthUserInfo:YES];
                } cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
            }else {
                [self showAuthUserInfo:YES];
            }
        }else{
            [self showAuthUserInfo:NO];
        }
    }];
    [self.navigationController pushViewController:pwdVc animated:YES];
    [self requestDate];
}
#pragma mark --获取用户信息
-(void)requestDate{
    dispatch_async(dispatch_queue_create(0, 0), ^{
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"userInfo" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            UserInfoModel *model=[[UserInfoModel alloc]initWithDictionary:result[RESULT_DATA][@"user"]];
            self.usermodel=model;
            dispatch_async(dispatch_get_main_queue(), ^{//主线程更新内容
                [[UserInfoManager shareUserManager]updateUserInfo:@{Key_Mobile:self.usermodel.phone,Key_RealName:self.usermodel.reserveName,Key_Idcard:self.usermodel.identityard,Key_Trade_Password_State:self.usermodel.isSetPassword,Key_Bankcard_State:self.usermodel.isSetBank,Key_Sign_State:self.usermodel.isSign,Key_Profit:self.usermodel.profit,Key_EstProfit:self.usermodel.estimateProfit,Key_TotalAss:self.usermodel.totalAssets,Key_Balance:self.usermodel.balance,Key_WithdrawPrice:self.usermodel.withdrawalsPrice,Key_InvestPrice:self.usermodel.investmentPrice}];
            });
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [SpringAlertView showMessage:errorDescription];
        }];
        
    });           // 子线程执行任务（比如获取较大数据）
}
-(void)showAuthUserInfo:(BOOL)isgesture{
    [AlertViewManager showInViewController:self title:@"" message:(isgesture?@"手势设置成功\n恭喜您注册成功！快去设置交易密码并绑定银行卡，立即开始投资之旅！":@"恭喜您注册成功！快去设置交易密码并绑定银行卡，立即开始投资之旅！") clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            GuideSetexchangePwdVC *pwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetexchangePwdVC class])];
            [self.navigationController pushViewController:pwd animated:YES];
        }else{
            [(LoginNavigationVController *)self.navigationController dismissLoginSuccess:YES completion:nil];
        }
    } cancelButtonTitle:@"暂不操作" otherButtonTitles:@"立即前往", nil];
    
}
-(void)setPhone:(LimitTextField *)phone{
    _phone=phone;
    @weakify(self)
    [[_phone rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationRegist];
    }];
}
-(void)setVerifyCode:(LimitTextField *)verifyCode{
    _verifyCode=verifyCode;
    @weakify(self)
    [[_verifyCode rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationRegist];
    }];
}
-(void)setPassword:(LimitTextField *)password{
    _password=password;
    @weakify(self)
    [[_password rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationRegist];
    }];
}
-(void)validationRegist{
    if (self.phone.isSuccess&&self.password.isSuccess&&self.verifyCode.isSuccess) {
        self.registBtn.enabled=YES;
        [self.registBtn setBackgroundColor:BtnColor];
    }else{
        self.registBtn.enabled=NO;
        [self.registBtn setBackgroundColor:BtnUnColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
