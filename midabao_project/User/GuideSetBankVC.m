//
//  GuideSetBankVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "GuideSetBankVC.h"
#import "LoginNavigationVController.h"
#import "LimitTextField.h"
#import "UserInfoManager.h"
#import "VerifyCodeButton.h"
#import "IntersectedTextField.h"
#import "MyCenterVController.h"
#import "verifiyAlertView.h"
#import "IdcardTextField.h"
@interface GuideSetBankVC ()<UITextFieldDelegate,verifyDelegate>
@property (weak, nonatomic) IBOutlet LimitTextField *realName;

@property (weak, nonatomic) IBOutlet IdcardTextField *idCard;

@property (weak, nonatomic) IBOutlet IntersectedTextField *bankCard;

@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet LimitTextField *bankPhone;
@property (weak, nonatomic) IBOutlet UIButton *bangdingBankBtn;

@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIButton *idCardX;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)verifiyAlertView *verifyView;
@property (copy,nonatomic)NSString *serialNumber;
@end

@implementation GuideSetBankVC
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
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
        [self popViewControllerWithISpush];
    }];
    [self validationBinding];
    
    // Do any additional setup after loading the view.
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    return YES;
}
- (void)popViewControllerWithISpush{
    if ([self.navigationController isKindOfClass:[LoginNavigationVController class]]) {
        [(LoginNavigationVController *)self.navigationController dismissLoginSuccess:YES completion:nil];
    } else {
        if (self.navigationController.viewControllers.count>2) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (IBAction)rightBankClick:(id)sender {
    [self.view endEditing:YES];
    NSString *bankname=@"";
    if (![self.bankName.text isEqualToString:@"发卡行：未知"]) {
        bankname=[[self.bankName.text componentsSeparatedByString:@"："] lastObject];
    }

    NSString *bankCard=[self.bankCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *idcard=[self.idCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"bankQpply" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"name":self.realName.text,@"identityCard":idcard,@"bankCard":bankCard,@"reservePhone":self.bankPhone.text,@"bankName":bankname} success:^(NSURLSessionTask *task, id result) {
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
    NSString *idcard=[self.idCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BaseIndicatorView showInView:[UIApplication sharedApplication].keyWindow maskType:kIndicatorMaskAll];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"bindBank" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"name":self.realName.text,@"identityCard":idcard,@"bankCard":bankCard,@"reservePhone":self.bankPhone.text,@"code":code,@"bankName":bankname,@"reqSn":self.serialNumber} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self.verifyView.backTefiled resignFirstResponder];
        [self.view endEditing:YES];
        [[UserInfoManager shareUserManager].userInfo didSaveBankcardState:YES];
        [[UserInfoManager shareUserManager].userInfo didCertifiedState:YES];
        [SpringAlertView showMessage:@"恭喜您绑卡成功！"];
        [self popViewControllerWithISpush];
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

-(void)setRealName:(LimitTextField *)realName{
    _realName=realName;
    @weakify(self)
    [[_realName rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
    }];
}
-(void)setIdCard:(IdcardTextField *)idCard{
    _idCard=idCard;
    _idCard.filter = @"[0-9Xx]*";
    @weakify(self)
    [[_idCard rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
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
    if (self.realName.isSuccess&&self.idCard.isSuccess&&self.bankCard.success&&self.bankPhone.success) {
        self.bangdingBankBtn.enabled=YES;
        [self.bangdingBankBtn setBackgroundColor:BtnColor];
    }else{
        self.bangdingBankBtn.enabled=NO;
        [self.bangdingBankBtn setBackgroundColor:BtnUnColor];
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
- (void)keyboardDidShow:(NSNotification *)notification {
    
    [self changeIdCardX:YES notification:notification];
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
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self changeIdCardX:NO notification:notification];
    if (self.verifyView) {
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [self.verifyView hideViewwithanimate:NO];
        if (self.verifyView) {
            [self.verifyView removeFromSuperview];
            self.verifyView=nil;
        }
    }
}
- (void)changeIdCardX:(BOOL)isShow notification:(NSNotification *)notification {
    
    self.idCardX.hidden = (self.idCard != self.currentTextField) | !isShow;//notification.object ==  self.currentTextField ? : !isShow;
    
    if (!self.idCardX.superview && notification) {
        
        CGRect keyboardEndFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect buttonEndFrame = CGRectMake(keyboardEndFrame.origin.x, (NSInteger)( UISCREEN_HEIGHT - keyboardEndFrame.size.height/4), (NSInteger)(keyboardEndFrame.size.width/3), (NSInteger)(keyboardEndFrame.size.height/3.5));
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [window addSubview:self.idCardX];
        
        self.idCardX.frame = buttonEndFrame;
    }
}

- (UIButton *)idCardX {
    
    if (!_idCardX) {
        _idCardX = [[UIButton alloc] init];
        
        _idCardX.titleLabel.textAlignment = NSTextAlignmentCenter;
        _idCardX.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [_idCardX setTitle:@"X" forState:UIControlStateNormal];
        [_idCardX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_idCardX addTarget:self action:@selector(addX:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _idCardX;
}
- (void)addX:(UIButton *)sender {
    
    if (sender.superview && !sender.hidden) {
        
        self.idCard.text = [self.idCard.text stringByAppendingString:sender.currentTitle];
        [self.idCard textDidChange];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    if (_idCardX.superview)
        [_idCardX removeFromSuperview];
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
