//
//  MyBankVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyBankVController.h"
#import "UserInfoManager.h"
#import "AddBankVController.h"
#import "AddBankHaveNameVC.h"
#import "GuideSetexchangePwdVC.h"
#import "UIImageView+LoadImage.h"
#import "BankInfoModel.h"
#import "FindingTransactionVC.h"
#import "GestureNavigationController.h"
#import "NSString+ExtendMethod.h"
@interface MyBankVController ()
@property (weak, nonatomic) IBOutlet UIView *addBankView;
@property (weak, nonatomic) IBOutlet UIView *myBankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)BankInfoModel *bankModel;
@end

@implementation MyBankVController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.myBankView.hidden=YES;
    self.addBankView.hidden=[UserInfoManager shareUserManager].userInfo.bankcardstate;
    if ([UserInfoManager shareUserManager].userInfo.bankcardstate) {
        [self getBankInfoData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBankClick)];
    [self.addBankView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)getBankInfoData{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"queryBank" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        self.bankModel=[BankInfoModel yy_modelWithJSON:[result[RESULT_DATA][@"bankList"]firstObject]];
        [self configUI];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(void)configUI{
    if (self.bankModel) {
        self.myBankView.hidden=![UserInfoManager shareUserManager].userInfo.bankcardstate;
        self.bankName.text=self.bankModel.bankName;
        self.bankNumber.text=self.bankModel.bankCard;
        [self.bankIcon loadFKImageWithPath:[CommonTools convertToStringWithObject:self.bankModel.bankImg]];
    }
    
}
-(void)addBankClick{
    if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//如果没有设置交易密码的时候先进行设置交易密码
        [AlertViewManager showInViewController:self title:@"温馨提示" message:@"您还设置交易密码，请先设置交易密码！" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                GuideSetexchangePwdVC *pwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetexchangePwdVC class])];
                [self.navigationController pushViewController:pwd animated:YES];
                
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }else if (![UserInfoManager shareUserManager].userInfo.certifierstate){//设置了交易密码没有实名认证
        AddBankVController *addBankVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AddBankVController class])];
        [self.navigationController pushViewController:addBankVc animated:YES];
    }else{//已经实名认证
        AddBankHaveNameVC *addBank=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AddBankHaveNameVC class])];
        [self.navigationController pushViewController:addBank animated:YES];

    }
}
- (IBAction)relieveBankClick:(id)sender {
    
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证交易密码" preferredStyle:UIAlertControllerStyleAlert];
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControler addAction:cancelAction];
    //确定按钮
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pwd = alertControler.textFields.firstObject;
        if (pwd.text.length>0) {
            [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
            dispatch_async(dispatch_queue_create(0, 0), ^{
                @weakify(self)
                self.operation=[NetWorkOperation SendRequestWithMethods:@"paypwdVerify" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"payPwd":[[[NSString stringWithFormat:@"%@%@",pwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
                    @strongify(self)
                    dispatch_async(dispatch_queue_create(0, 0), ^{
                        self.operation =[NetWorkOperation SendRequestWithMethods:@"bankUnband" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"cardId":self.bankModel.cardId} success:^(NSURLSessionTask *task, id result) {
                            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                                [BaseIndicatorView hide];
                                [[UserInfoManager shareUserManager].userInfo didSaveBankcardState:NO];
                                self.myBankView.hidden=![UserInfoManager shareUserManager].userInfo.bankcardstate;
                                self.addBankView.hidden=[UserInfoManager shareUserManager].userInfo.bankcardstate;
                                [SpringAlertView showMessage:@"解绑银行卡成功！"];
                            });
                        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                            [BaseIndicatorView hide];
                            [SpringAlertView showMessage:errorDescription];
                        }];
                    });
                } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                    [BaseIndicatorView hide];
                    [SpringAlertView showMessage:errorDescription];
                }];
                
            });
        }else{
            [SpringAlertView showMessage:@"请输入交易密码"];
        }
        
    }];
    [alertControler addAction:OkAction];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        FindingTransactionVC *findPayPwdVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([FindingTransactionVC class])];
        GestureNavigationController *navc=[[GestureNavigationController alloc]initWithRootViewController:findPayPwdVc];
        [self presentViewController:navc animated:YES completion:nil];
    }];
    [alertControler addAction:Action];
    [alertControler addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"输入交易密码";
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertControler animated:YES completion:nil];
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
