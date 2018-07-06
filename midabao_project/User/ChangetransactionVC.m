

//
//  ChangetransactionVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ChangetransactionVC.h"
#import "LimitTextField.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
@interface ChangetransactionVC ()
@property (weak, nonatomic) IBOutlet LimitTextField *oldPwd;
@property (weak, nonatomic) IBOutlet LimitTextField *newsPwd;
@property (weak, nonatomic) IBOutlet LimitTextField *surePwd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation ChangetransactionVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self verifySubmitBtn];
    // Do any additional setup after loading the view.
}

- (IBAction)submitBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![self.newsPwd.text isEqualToString:self.surePwd.text]) {
        [SpringAlertView showMessage:@"两次密码输入不一致！"];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"updatePayPwd" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"oldPayPwd":[[[NSString stringWithFormat:@"%@%@",self.oldPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString],@"newPayPwd":[[[NSString stringWithFormat:@"%@%@",self.newsPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:@"修改成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [BaseIndicatorView hide];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}

-(void)setOldPwd:(LimitTextField *)oldPwd{
    _oldPwd=oldPwd;
    @weakify(self)
    [[_oldPwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
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
-(void)setSurePwd:(LimitTextField *)surePwd{
    _surePwd=surePwd;
    @weakify(self)
    [[_surePwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self verifySubmitBtn];
    }];
}
-(void)verifySubmitBtn{
    if (self.oldPwd.success&&self.newsPwd.success&&self.surePwd.success) {
        self.sureBtn.enabled=YES;
        [self.sureBtn setBackgroundColor:BtnColor];
    }else{
        self.sureBtn.enabled=NO;
        [self.sureBtn setBackgroundColor:BtnUnColor];
    }
}
- (IBAction)seeMyPwdclick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.oldPwd.secureTextEntry=!sender.selected;
    self.newsPwd.secureTextEntry=!sender.selected;
    self.surePwd.secureTextEntry=!sender.selected;
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
