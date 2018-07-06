
//
//  WithdrawVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "WithdrawVController.h"
#import "LimitTextField.h"
#import "UserInfoManager.h"
#import "BankInfoModel.h"
#import "UILabel+Format.h"
#import "UIImageView+LoadImage.h"
#import "RechargeOrWithdrawSuccessVC.h"
#import "GestureNavigationController.h"
#import "FindingTransactionVC.h"
#import "ServiceCenterVC.h"
#import "NSString+ExtendMethod.h"
@interface WithdrawVController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myBalance;
@property (weak, nonatomic) IBOutlet UILabel *freewithdrawNum;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankCard;
@property (weak, nonatomic) IBOutlet UILabel *limtLab;
@property (weak, nonatomic) IBOutlet LimitTextField *withdrawMoney;
@property (weak, nonatomic) IBOutlet UILabel *realMoney;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLab;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UILabel *daozhangTime;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)BankInfoModel *bankModel;
@property (strong,nonatomic)NSDictionary *resultData;
@property (copy , nonatomic)NSString *balanceStr;
@property (copy , nonatomic)NSString *shouxuStr;
@end

@implementation WithdrawVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouxuStr=@"0";
    self.balanceStr=@"0";
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self validationWithdraw];
    [self refirshUI];
    self.withdrawMoney.delegate=self;
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.bankModel.eachPrice doubleValue]>0) {
            if (([self.balanceStr doubleValue]-[self.shouxuStr doubleValue])>[self.bankModel.eachPrice doubleValue]*10000) {//余额大于单笔限额
                if ([self.withdrawMoney.text doubleValue]>[self.bankModel.eachPrice doubleValue]*10000) {//如果提现金额大于单笔限额
                    self.withdrawMoney.text=[NSString stringWithFormat:@"%.2f",[self.bankModel.eachPrice doubleValue]*10000];
                }
            }else{
                if (([self.balanceStr doubleValue]-[self.shouxuStr doubleValue])<[self.withdrawMoney.text doubleValue]) {//如果提现金额大于充值金额
                    self.withdrawMoney.text=[NSString stringWithFormat:@"%.2f",([self.balanceStr doubleValue]-[self.shouxuStr doubleValue])];
                }
            }
        }else if (([self.balanceStr doubleValue]-[self.shouxuStr doubleValue])<[self.withdrawMoney.text doubleValue]) {//如果提现金额大于充值金额
            self.withdrawMoney.text=[NSString stringWithFormat:@"%.2f",([self.balanceStr doubleValue]-[self.shouxuStr doubleValue])];
        }
        if (self.withdrawMoney.text.doubleValue>0) {
            self.realMoney.text=[NSString stringWithFormat:@"%.2f",[self.withdrawMoney.text doubleValue]+[self.shouxuStr doubleValue]];
        }else{
            self.realMoney.text=@"0.00";
        }
        
    }];
    // Do any additional setup after loading the view.
}

-(void)refirshUI{
    if ([UserInfoManager shareUserManager].userInfo.userid) {
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        dispatch_async(dispatch_queue_create(0, 0), ^{
            @weakify(self)
            self.operation=[NetWorkOperation SendRequestWithMethods:@"queryBank" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                BankInfoModel *model=[BankInfoModel yy_modelWithJSON:[result[RESULT_DATA][@"bankList"]firstObject]];
                self.bankModel=model;
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    self.operation=[NetWorkOperation SendRequestWithMethods:@"bankinfoQuery" params:@{@"bankName":self.bankModel.bankName,@"type":@(2),@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
                        self.resultData=result[RESULT_DATA];
                        dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                            [BaseIndicatorView hide];
                            self.balanceStr=[UserInfoManager shareUserManager].userInfo.balance;
                            [self.myBalance floatformatNumber:self.balanceStr andSubText:@""];
                            self.bankName.text=self.bankModel.bankName;
                            [self.bankIcon loadFKImageWithPath:self.bankModel.bankImg];
                            self.bankCard.text=self.bankModel.bankCard;
                            if ([self.bankModel.eachPrice integerValue]>0&&[self.bankModel.everydayPrice integerValue]>0) {
                                self.limtLab.text=[NSString stringWithFormat:@"单笔%@万，单日%@万",self.bankModel.eachPrice,self.bankModel.everydayPrice];
                            }else if([self.bankModel.eachPrice integerValue]>0){
                                self.limtLab.text=[NSString stringWithFormat:@"单笔%@万",self.bankModel.eachPrice];
                            }else if ([self.bankModel.everydayPrice integerValue]>0){
                                self.limtLab.text=[NSString stringWithFormat:@"单日%@万",self.bankModel.everydayPrice];
                            }else{
                                self.limtLab.text=@"";
                            }
                            self.freewithdrawNum.text=[NSString stringWithFormat:@"本月剩余免费提现次数：%@次",[CommonTools convertToStringWithObject:self.resultData[@"each"]]];
                            self.shouxuStr=[CommonTools convertFoloatToStringWithObject:self.resultData[@"serviceCharge"]];
                            self.shouxuLab.text=[NSString stringWithFormat:@"手续费：%@元",self.shouxuStr];
                            NSString *huankuanTime=[CommonTools convertToStringWithObject:self.resultData[@"time"]];
                            NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[huankuanTime integerValue]/1000];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy.MM.dd"];
                            self.daozhangTime.text=[NSString stringWithFormat:@"预计到账时间：%@",[formatter stringFromDate:date1]];
                            
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

    }
}
//在UITextField的代理方法中添加类似如下代码
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (int i = (int)futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}
- (IBAction)clcikWithdrawBtn:(id)sender {
    //这里是关键，点击按钮后先取消之前的操作，再进行需要进行的操作
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(WithdrawbuttonClicked:) object:sender];
    [self performSelector:@selector(WithdrawbuttonClicked:)withObject:sender afterDelay:0.2f];
}
-(void)WithdrawbuttonClicked:(UIButton *)btn{
    [self.view endEditing:YES];
    self.withdrawBtn.enabled = NO;
    [self performSelector:@selector(WithdrawchangeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
    if ([self.withdrawMoney.text integerValue]==0) {
        [SpringAlertView showMessage:@"提现金额不能为零"];
        return;
    }
    if (self.bankModel.eachPrice.doubleValue>0) {
        if (self.withdrawMoney.text.doubleValue>(self.bankModel.eachPrice.doubleValue*10000)) {
            [SpringAlertView showMessage:@"提现金额不能大于单笔限额！"];
            return;
        }
    }
    if (self.withdrawMoney.text.doubleValue>self.balanceStr.doubleValue) {
        [SpringAlertView showMessage:@"提现金额不能大于当前余额！"];
        return;
    }
    if(self.bankModel){
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证交易密码" preferredStyle:UIAlertControllerStyleAlert];
        //取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControler addAction:cancelAction];
        //确定按钮
        UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *pwd = alertControler.textFields.firstObject;
            if (pwd.text.length>0) {
                [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskAll];
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    @weakify(self)
                    self.operation=[NetWorkOperation SendRequestWithMethods:@"paypwdVerify" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"payPwd":[[[NSString stringWithFormat:@"%@%@",pwd.text,APPSECRETVALUE] MD5Encryption]uppercaseString]} success:^(NSURLSessionTask *task, id result) {
                        @strongify(self)
                        dispatch_async(dispatch_queue_create(0, 0), ^{
                            self.operation=[NetWorkOperation SendRequestWithMethods:@"transactionSave" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"price":self.withdrawMoney.text,@"type":@(2),@"channel":@(2),@"bankName":self.bankModel.bankName} success:^(NSURLSessionTask *task, id result) {
                                dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                                    [BaseIndicatorView hide];
                                    RechargeOrWithdrawSuccessVC *buyVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([RechargeOrWithdrawSuccessVC class])];
                                    buyVc.currentType=2;
                                    GestureNavigationController *navc=[[GestureNavigationController alloc]initWithRootViewController:buyVc];
                                    [buyVc setCloseDown:^{
                                        @strongify(self)
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    }];
                                    [self presentViewController:navc animated:YES completion:nil];
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
    }else{
        [SpringAlertView showMessage:@"提现信息获取错误，请重新刷新页面"];
    }
}
-(void)WithdrawchangeButtonStatus{
    self.withdrawBtn.enabled=YES;
}
- (IBAction)clickAllbtn:(id)sender {
    if (self.bankModel.eachPrice.doubleValue>0) {
        if ((self.balanceStr.doubleValue-self.shouxuStr.doubleValue)>self.bankModel.eachPrice.doubleValue*10000) {
            self.withdrawMoney.text=[NSString stringWithFormat:@"%.2f",self.bankModel.eachPrice.doubleValue*10000];
        }else{
            self.withdrawMoney.text=[NSString stringWithFormat:@"%.2f",self.balanceStr.doubleValue-self.shouxuStr.doubleValue];
        }
        self.realMoney.text=[NSString stringWithFormat:@"%.2f",[self.withdrawMoney.text doubleValue]+[self.shouxuStr doubleValue]];
    }
    [self validationWithdraw];
}
- (IBAction)clickKFbtn:(id)sender {
    ServiceCenterVC *serviceVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ServiceCenterVC class])];
    [self.navigationController pushViewController:serviceVc animated:YES];
}

-(void)setWithdrawMoney:(LimitTextField *)withdrawMoney{
    _withdrawMoney=withdrawMoney;
    @weakify(self)
    [[_withdrawMoney rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationWithdraw];
    }];
}



-(void)validationWithdraw{
    if (self.withdrawMoney.success) {
        self.withdrawBtn.enabled=YES;
        [self.withdrawBtn setBackgroundColor:BtnColor];
    }else{
        self.withdrawBtn.enabled=NO;
        [self.withdrawBtn setBackgroundColor:BtnUnColor];
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
