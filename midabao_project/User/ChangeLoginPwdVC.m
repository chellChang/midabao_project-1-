


//
//  ChangeLoginPwdVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ChangeLoginPwdVC.h"
#import "FindPwdVController.h"
#import "LimitTextField.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
@interface ChangeLoginPwdVC ()
@property (weak, nonatomic) IBOutlet LimitTextField *oldPwd;
@property (weak, nonatomic) IBOutlet LimitTextField *newsLogPwd;

@property (weak, nonatomic) IBOutlet LimitTextField *surePwd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation ChangeLoginPwdVC
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
#pragma mark  --点击确认
- (IBAction)submitBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![self.newsLogPwd.text isEqualToString:self.surePwd.text]) {
        [SpringAlertView showMessage:@"两次密码输入不一致！"];
        return;
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"updateLoginPwd" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"oldLoginPwd":[[[NSString stringWithFormat:@"%@%@",self.oldPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString],@"newLoginPwd":[[[NSString stringWithFormat:@"%@%@",self.newsLogPwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
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


- (IBAction)findLoginPwdClick:(id)sender {
    [AlertViewManager showInViewController:self title:@"温馨提示" message:@"找回登录密码会退出当前账户，是否确定退出？" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [[UserInfoManager shareUserManager]logout];//清除登录信息
            [SpringAlertView showMessage:@"退出登录成功！"];
            FindPwdVController *findePwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForStoryboard:@"Login" controller:NSStringFromClass([FindPwdVController class])];
            findePwd.ischangeLogin=YES;
            [self.navigationController pushViewController:findePwd animated:YES];
        }
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
}
-(void)setOldPwd:(LimitTextField *)oldPwd{
    _oldPwd=oldPwd;
    @weakify(self)
    [[_oldPwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self verifySubmitBtn];
    }];
    
}
-(void)setNewsLogPwd:(LimitTextField *)newsLogPwd{
    _newsLogPwd=newsLogPwd;
    @weakify(self)
    [[_newsLogPwd rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
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
    if (self.oldPwd.success&&self.newsLogPwd.success&&self.surePwd.success) {
        self.submitBtn.enabled=YES;
        [self.submitBtn setBackgroundColor:BtnColor];
    }else{
        self.submitBtn.enabled=NO;
        [self.submitBtn setBackgroundColor:BtnUnColor];
    }
}
- (IBAction)seeMyPwdclick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.oldPwd.secureTextEntry=!sender.selected;
    self.newsLogPwd.secureTextEntry=!sender.selected;
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
