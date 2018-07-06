//
//  ChangeMyBindPhoneVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/23.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ChangeMyBindPhoneVC.h"
#import "IdcardTextField.h"
#import "VerifyCodeButton.h"
#import "NSString+ExtendMethod.h"
#import "UserInfoManager.h"
@interface ChangeMyBindPhoneVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet IdcardTextField *idCard;
@property (weak, nonatomic) IBOutlet LimitTextField *myPhone;
@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *verifyCodeBtn;
@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIButton *idCardX;
@property (strong,nonatomic)NetWorkOperation *operation;

@end

@implementation ChangeMyBindPhoneVC
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self validationBinding];
    self.name.text=[NSString stringWithFormat:@"姓名：%@",[[UserInfoManager shareUserManager].userInfo.realname hidePosition:kHideStringCenter length:[UserInfoManager shareUserManager].userInfo.realname.length/2]];
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

- (IBAction)verifyCodeBtnClick:(VerifyCodeButton *)sender {
    [self.view endEditing:YES];
    if (!self.myPhone.success) {
        [SpringAlertView showMessage:@"请输入正确的手机号！"];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    //获取验证码
    self.operation=[NetWorkOperation SendRequestWithMethods:@"getcode" params:@{@"phone":self.myPhone.text,VERIFY_CODE_TYPE_KEY:VERIFY_CHANGEPHONE} success:^(NSURLSessionTask *task, id result) {
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
- (IBAction)submitBtnClick:(id)sender {
    [self.view endEditing:YES];
    NSString *IdCard=[self.idCard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    self.operation=[NetWorkOperation SendRequestWithMethods:@"updatePhone" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"idCard":IdCard,@"phone":self.myPhone.text,@"code":self.verifyCode.text,@"codeType":VERIFY_CHANGEPHONE} success:^(NSURLSessionTask *task, id result) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:@"修改手机号成功！"];
        [[UserInfoManager shareUserManager]updateUserPhone:@{Key_Mobile:self.myPhone.text}];//更新手机信息
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];

    }];
}
- (void)keyboardDidShow:(NSNotification *)notification {
    
    [self changeIdCardX:YES notification:notification];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self changeIdCardX:NO notification:notification];
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
-(void)setMyPhone:(LimitTextField *)myPhone{
    _myPhone=myPhone;
    @weakify(self)
    [[_myPhone rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
    }];
}
-(void)setVerifyCode:(LimitTextField *)verifyCode{
    _verifyCode=verifyCode;
    @weakify(self)
    [[_verifyCode rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationBinding];
    }];
}

-(void)validationBinding{
    if (self.idCard.isSuccess&&self.myPhone.success&&self.verifyCode.success) {
        self.submitBtn.enabled=YES;
        [self.submitBtn setBackgroundColor:BtnColor];
    }else{
        self.submitBtn.enabled=NO;
        [self.submitBtn setBackgroundColor:BtnUnColor];
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
- (void)dealloc {
    if (_idCardX.superview)
        [_idCardX removeFromSuperview];
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
