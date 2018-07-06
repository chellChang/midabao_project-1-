
//
//  GuideSetexchangePwdVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "GuideSetexchangePwdVC.h"
#import "LimitTextField.h"
#import "GuideSetBankVC.h"
#import "UserInfoManager.h"
#import "LoginNavigationVController.h"
#import "NSString+ExtendMethod.h"
@interface GuideSetexchangePwdVC ()
@property (weak, nonatomic) IBOutlet LimitTextField *pwdTx;
@property (weak, nonatomic) IBOutlet LimitTextField *surePwdTx;
@property (weak, nonatomic) IBOutlet UIButton *nextStapeBtn;
@property (nonatomic,strong)NetWorkOperation *operation;
@end

@implementation GuideSetexchangePwdVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [self popViewController];
    }];
    [self validationNextStep];
    // Do any additional setup after loading the view.
}
- (void)popViewController {
    
    if ([self.navigationController isKindOfClass:[LoginNavigationVController class]]) {
        [(LoginNavigationVController *)self.navigationController dismissLoginSuccess:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (IBAction)nextStapeClcik:(id)sender {
    [self.view endEditing:YES];
    if (!self.pwdTx.success||!self.surePwdTx.success) {
        [SpringAlertView showMessage:@"密码格式不符合要求，请设置6~16位数字或字母组合！"];
        return;
    }
    if (![self.pwdTx.text isEqualToString:self.surePwdTx.text]) {
        [SpringAlertView showMessage:@"两次密码设置不一致"];
        return;
    }
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"paypwd" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"payPwd":[[[NSString stringWithFormat:@"%@%@",self.pwdTx.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:@"设置交易密码成功！"];
        [[UserInfoManager shareUserManager].userInfo didSetupTradePasswordState:YES];//存在交易密码
        //绑定银行卡
        GuideSetBankVC *bankVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetBankVC class])];
        [self.navigationController pushViewController:bankVc animated:YES];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
    
}

- (IBAction)isSeePwdBtnClick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.pwdTx.secureTextEntry=!sender.selected;
    self.surePwdTx.secureTextEntry=!sender.selected;
}
-(void)setPwdTx:(LimitTextField *)pwdTx{
    _pwdTx=pwdTx;
    @weakify(self)
    [[_pwdTx rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationNextStep];
    }];
}
-(void)setSurePwdTx:(LimitTextField *)surePwdTx{
    _surePwdTx=surePwdTx;
    @weakify(self)
    [[_surePwdTx rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationNextStep];
    }];

}
-(void)validationNextStep{
    if (self.pwdTx.success&&self.surePwdTx.success) {
        self.nextStapeBtn.enabled=YES;
        [self.nextStapeBtn setBackgroundColor:BtnColor];
    }else{
        self.nextStapeBtn.enabled=NO;
        [self.nextStapeBtn setBackgroundColor:BtnUnColor];
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
