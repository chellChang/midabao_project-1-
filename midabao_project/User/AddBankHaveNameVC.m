
//
//  AddBankHaveNameVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "AddBankHaveNameVC.h"
#import "IntersectedTextField.h"
#import "VerifyCodeButton.h"
#import "NSString+ExtendMethod.h"
#import "UserInfoManager.h"
#import "verifiyAlertView.h"
@interface AddBankHaveNameVC ()<verifyDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idCard;
@property (weak, nonatomic) IBOutlet IntersectedTextField *bankCard;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet LimitTextField *bankPhone;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)verifiyAlertView *verifyView;
@property (copy,nonatomic)NSString *serialNumber;
@end

@implementation AddBankHaveNameVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.serialNumber=@"";
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self validationBinding];
    self.name.text=[NSString stringWithFormat:@"姓名：%@",[[UserInfoManager shareUserManager].userInfo.realname hidePosition:kHideStringCenter length:[UserInfoManager shareUserManager].userInfo.realname.length/2]];
    self.idCard.text=[NSString stringWithFormat:@"身份证号：%@",[[UserInfoManager shareUserManager].userInfo.idcard hidePosition:kHideStringCenter length:[UserInfoManager shareUserManager].userInfo.idcard.length/2]];

    // Do any additional setup after loading the view.
}
-(void)keyboardwillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    if (self.verifyView) {
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.verifyView.frame=CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-height+30);
            
        }];
    }
    
}
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{

    if (self.verifyView) {
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [self.verifyView hideViewwithanimate:NO];
        if (self.verifyView) {
            [self.verifyView removeFromSuperview];
            self.verifyView=nil;
        }
        
    
    }
    
}

- (IBAction)bindBtnClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSString *bankname=@"";
    if (![self.bankName.text isEqualToString:@"发卡行：未知"]) {
        bankname=[[self.bankName.text componentsSeparatedByString:@"："] lastObject];
    }
    NSString *bankCard=[self.bankCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"bankQpply" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"name":@"杨晓晖",@"identityCard":@"110101198601040010",@"bankCard":bankCard,@"reservePhone":self.bankPhone.text,@"bankName":bankname} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self inputVierifyCode];
        [self.verifyView.getverifyCode countDown:AUTHCODE_REPEAT_INTERVAL];
        [SpringAlertView showMessage:@"验证码已发送，请查收！"];
        self.serialNumber=result[RESULT_DATA][@"reqSn"];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(void)inputVierifyCode{
    self.verifyView=[[verifiyAlertView alloc]initAlertViewWithframe:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    [self.verifyView.backTefiled becomeFirstResponder];
    self.verifyView.delelgate=self;
    UIWindow *windown=[UIApplication sharedApplication].keyWindow;
    [windown addSubview:self.verifyView];
}
#pragma mark --verify的代理
-(void)VerifycodeGoRequestWithCode:(NSString *)code{
    
    NSString *bankname=@"";
    if (![self.bankName.text isEqualToString:@"发卡行：未知"]) {
        bankname=[[self.bankName.text componentsSeparatedByString:@"："] lastObject];
    }
    NSString *bankCard=[self.bankCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BaseIndicatorView showInView:[UIApplication sharedApplication].keyWindow maskType:kIndicatorMaskAll];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"bindBank" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"name":@"杨晓晖",@"identityCard":@"110101198601040010",@"bankCard":bankCard,@"reservePhone":self.bankPhone.text,@"code":code,@"bankName":bankname,@"reqSn":self.serialNumber} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self.verifyView.backTefiled resignFirstResponder];
        [self.view endEditing:YES];
        [[UserInfoManager shareUserManager].userInfo didSaveBankcardState:YES];
        [[UserInfoManager shareUserManager].userInfo didCertifiedState:YES];
        [SpringAlertView showMessage:@"绑定成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        self.verifyView.oneLable.text=@"";
        self.verifyView.twoLable.text=@"";
        self.verifyView.threeLab.text=@"";
        self.verifyView.fourLable.text=@"";
        self.verifyView.backTefiled.text=@"";
        [SpringAlertView showMessage:errorDescription];
    }];
}
#pragma mark --重新发送验证码
-(void)agaginVerifyCode{
    [BaseIndicatorView showInView:[UIApplication sharedApplication].keyWindow maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"bankCodeGet" params:@{@"reqSn":self.serialNumber} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self.verifyView.getverifyCode countDown:AUTHCODE_REPEAT_INTERVAL];
        [SpringAlertView showMessage:@"验证码已发送，请查收！"];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(void)setBankCard:(IntersectedTextField *)bankCard{
    _bankCard=bankCard;
    @weakify(self)
    [[_bankCard rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
        NSString *card=[x stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (card.length>=8&&card.length<10) {
            [self getBankName:card];
        }else if(card.length<6){
            self.bankName.text=@"发卡行：未知";
        }
    }];
}

-(void)setBankPhone:(LimitTextField *)bankPhone{
    _bankPhone=bankPhone;
    @weakify(self)
    [[_bankPhone rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
    }];
}
-(void)validationBinding{
    if (self.bankCard.isSuccess&&self.bankPhone.isSuccess) {
        self.bindBtn.enabled=YES;
        [self.bindBtn setBackgroundColor:BtnColor];
    }else{
        self.bindBtn.enabled=NO;
        [self.bindBtn setBackgroundColor:BtnUnColor];
    }
}
-(void)getBankName:(NSString *)idCard{
    if (idCard.length>=8) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
        NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *bankBin = resultDic.allKeys;
        //6位Bin号
        NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
        //8位Bin号
        NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
        
        if ([bankBin containsObject:cardbin_6]) {
            self.bankName.text=[NSString stringWithFormat:@"发卡行：%@",[[[resultDic objectForKey:cardbin_6] componentsSeparatedByString:@"·"]firstObject]];
        }else if ([bankBin containsObject:cardbin_8]){
            self.bankName.text=[NSString stringWithFormat:@"发卡行：%@",[[[resultDic objectForKey:cardbin_8] componentsSeparatedByString:@"."]firstObject]];
        }else{
            self.bankName.text=@"发卡行：未知";
        }
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
