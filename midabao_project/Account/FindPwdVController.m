
//
//  FindPwdVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FindPwdVController.h"
#import "LimitTextField.h"
#import "LoginNavigationVController.h"
#import "VerifyCodeButton.h"
#import "UserInfoManager.h"
#import "SetGesturePwdVC.h"
#import "UserInfoModel.h"
#import "NSString+ExtendMethod.h"
@interface FindPwdVController ()
@property (weak, nonatomic) IBOutlet LimitTextField *myPhone;
@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
@property (weak, nonatomic) IBOutlet LimitTextField *myPwd;
@property (weak, nonatomic) IBOutlet UIButton *findmyPwdBtn;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollview;
@property (strong,nonatomic)UserInfoModel *usermodel;

@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation FindPwdVController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        if (self.ischangeLogin) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
     [self validationFindpwd];
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
- (void)popViewController {
    if ([self.navigationController isKindOfClass:[LoginNavigationVController class]]) {
        [(LoginNavigationVController *)self.navigationController dismissLoginSuccess:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
- (IBAction)getVerifyClick:(id)sender {
    [self.view endEditing:YES];
    if (!self.myPhone.success) {
        [SpringAlertView showInWindow:self.view.window message:@"请输入正确手机号"];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    
    @weakify(self)
    //获取验证码
    self.operation=[NetWorkOperation SendRequestWithMethods:@"getcode" params:@{@"phone":self.myPhone.text,VERIFY_CODE_TYPE_KEY:VERIFY_FINDLOGINPWD} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
//        NSLog(@"--code:%@",result[RESULT_DATA][@"code"]);
        [SpringAlertView showInWindow:self.view.window message:@"已发送验证码，请注意查收短信息"];
        [self.verifyCodeBtn countDown:AUTHCODE_REPEAT_INTERVAL];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (IBAction)findMyPwdClick:(id)sender {
    [self.view endEditing:YES];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"findloginPwd" params:@{@"phone":self.myPhone.text,@"code":self.verifyCode.text,@"codeType":VERIFY_FINDLOGINPWD,@"newLoginPwd":[[[NSString stringWithFormat:@"%@%@",self.myPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:@"找回密码并登录成功！"];
        //存储用户信息
        [[UserInfoManager shareUserManager]updateLoginInfo:@{Key_UserID:result[RESULT_DATA][@"userId"],Key_Token:result[RESULT_DATA][@"token"]}];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_GESTURE]) {//设置手势密码
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
                            [self popViewController];
                        } cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
                    }else {
                        [self popViewController];
                    }
                }else{
                    [self popViewController];
                }
            }];
            [self.navigationController pushViewController:pwdVc animated:YES];
        }else{
            [self popViewController];
        }
       
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
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
- (IBAction)pwdisSeeClick:(id)sender {
    UIButton *btn=sender;
    btn.selected=!btn.selected;
    self.myPwd.secureTextEntry=!btn.selected;
}
-(void)setVerifyCode:(LimitTextField *)verifyCode{
     _verifyCode=verifyCode;
    @weakify(self)
    [[_verifyCode rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationFindpwd];
    }];
}

-(void)setMyPwd:(LimitTextField *)myPwd{
    _myPwd=myPwd;
    @weakify(self)
    [[_myPwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationFindpwd];
    }];
}
-(void)setMyPhone:(LimitTextField *)myPhone{
    _myPhone=myPhone;
    @weakify(self)
    [[_myPhone rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationFindpwd];
    }];
}

-(void)validationFindpwd{
    if (self.myPhone.success&&self.myPwd.success&&self.verifyCode.success) {
        self.findmyPwdBtn.enabled=YES;
        [self.findmyPwdBtn setBackgroundColor:BtnColor];
    }else{
        self.findmyPwdBtn.enabled=NO;
        [self.findmyPwdBtn setBackgroundColor:BtnUnColor];
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
