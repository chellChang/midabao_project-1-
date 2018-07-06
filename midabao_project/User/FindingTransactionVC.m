//
//  FindingTransactionVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FindingTransactionVC.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
#import "LimitTextField.h"
#import "VerifyCodeButton.h"
#import "UserInfoManager.h"
@interface FindingTransactionVC ()
@property (weak, nonatomic) IBOutlet UILabel *myPhone;
@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet LimitTextField *newsPwd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation FindingTransactionVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation  cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myPhone.text=[NSString stringWithFormat:@"绑定手机：%@",[[UserInfoManager shareUserManager].userInfo.mobile hidePosition:kHideStringCenter length:[UserInfoManager shareUserManager].userInfo.mobile.length/2]];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        if (self.presentingViewController) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [viewController.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self verifySubmitBtn];
    // Do any additional setup after loading the view.
}
- (IBAction)verifyCodeBtnClick:(VerifyCodeButton *)sender {
    [self.view endEditing:YES];
    if ([[UserInfoManager shareUserManager].userInfo.mobile isEqualToString:@""]) {
        [SpringAlertView showMessage:@"手机号不正确！"];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    //获取验证码
    self.operation=[NetWorkOperation SendRequestWithMethods:@"getcode" params:@{@"phone":[UserInfoManager shareUserManager].userInfo.mobile,VERIFY_CODE_TYPE_KEY:VERIFY_FINDTRAPWD} success:^(NSURLSessionTask *task, id result) {
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
- (IBAction)findBtnClick:(id)sender {
    [self.view endEditing:YES];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"findPayPwd" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"code":self.verifyCode.text,@"codeType":VERIFY_FINDTRAPWD,@"phone":[UserInfoManager shareUserManager].userInfo.mobile,@"PayPwd":[[[NSString stringWithFormat:@"%@%@",self.newsPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:@"修改成功！"];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            if (self.navigationController.viewControllers.count>2) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];

}
-(void)setVerifyCode:(LimitTextField *)verifyCode{
    _verifyCode=verifyCode;
    @weakify(self)
    [[_verifyCode rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self verifySubmitBtn];
    }];
}
-(void)setNewsPwd:(LimitTextField *)newsPwd{
    _newsPwd=newsPwd;
    @weakify(self)
    [[_newsPwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self verifySubmitBtn];
    }];
}
-(void)verifySubmitBtn{
    if (self.verifyCode.success&&self.newsPwd.success) {
        self.submitBtn.enabled=YES;
        [self.submitBtn setBackgroundColor:BtnColor];
    }else{
        self.submitBtn.enabled=NO;
        [self.submitBtn setBackgroundColor:BtnUnColor];
    }
}
- (IBAction)seeMyPwdclick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.newsPwd.secureTextEntry=!sender.selected;
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
