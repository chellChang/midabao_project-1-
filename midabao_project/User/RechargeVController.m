

//
//  RechargeVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "RechargeVController.h"
#import "LimitTextField.h"
#import "UserInfoManager.h"
#import "BankInfoModel.h"
#import "UILabel+Format.h"
#import "UIImageView+LoadImage.h"
#import "RechargeOrWithdrawSuccessVC.h"
#import "GestureNavigationController.h"
#import "ServiceCenterVC.h"

@interface RechargeVController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;
@property (weak, nonatomic) IBOutlet UILabel *limtLab;
@property (weak, nonatomic) IBOutlet LimitTextField *rechargeMoney;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (nonatomic,strong)NetWorkOperation *operation;
@property (strong,nonatomic)BankInfoModel *bankModel;
@end

@implementation RechargeVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self validationRecharge];
    [self refirshUI];
    self.rechargeMoney.delegate=self;
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.bankModel.eachPrice doubleValue]>0) {
            if ([self.rechargeMoney.text doubleValue]>[self.bankModel.eachPrice doubleValue]*10000) {
                self.rechargeMoney.text=[NSString stringWithFormat:@"%.0f",[self.bankModel.eachPrice doubleValue]*10000];
            }
        }
        
    }];
    // Do any additional setup after loading the view.
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
-(void)refirshUI{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    dispatch_async(dispatch_queue_create(0, 0), ^{
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"queryBank" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            BankInfoModel *model=[BankInfoModel yy_modelWithJSON:[result[RESULT_DATA][@"bankList"]firstObject]];
            self.bankModel=model;
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                [BaseIndicatorView hide];
                [self.balanceLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.balance andSubText:@""];
                self.bankName.text=self.bankModel.bankName;
                [self.bankIcon loadFKImageWithPath:self.bankModel.bankImg];
                self.bankNumber.text=self.bankModel.bankCard;
                if ([self.bankModel.eachPrice integerValue]>0&&[self.bankModel.everydayPrice integerValue]>0) {
                    self.limtLab.text=[NSString stringWithFormat:@"单笔%@万，单日%@万",self.bankModel.eachPrice,self.bankModel.everydayPrice];
                }else if([self.bankModel.eachPrice integerValue]>0){
                    self.limtLab.text=[NSString stringWithFormat:@"单笔%@万",self.bankModel.eachPrice];
                }else if ([self.bankModel.everydayPrice integerValue]>0){
                    self.limtLab.text=[NSString stringWithFormat:@"单日%@万",self.bankModel.everydayPrice];
                }else{
                    self.limtLab.text=@"";
                }
                if (![self.needreachMoney isEqualToString:@""]&&self.needreachMoney!=nil&&![self.needreachMoney isKindOfClass:[NSNull class]]) {
                    if ([self.needreachMoney integerValue]>([self.bankModel.eachPrice integerValue]*10000)) {
                        self.rechargeMoney.text=[NSString stringWithFormat:@"%ld",([self.bankModel.eachPrice integerValue]*10000)];
                    }else{
                        self.rechargeMoney.text=self.needreachMoney;
                    }
                }
                [self validationRecharge];
                
            });
            
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [SpringAlertView showMessage:errorDescription];
        }];
        
    });
}
- (IBAction)clickRechargeBtn:(id)sender {
    //这里是关键，点击按钮后先取消之前的操作，再进行需要进行的操作
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(ReachbuttonClicked:) object:sender];
    [self performSelector:@selector(ReachbuttonClicked:)withObject:sender afterDelay:0.2f];
}
-(void)ReachbuttonClicked:(id)sender{
    [self.view endEditing:YES];
    self.rechargeBtn.enabled = NO;
    [self performSelector:@selector(ReachchangeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
    if (self.bankModel.eachPrice.doubleValue>0) {
        if (self.rechargeMoney.text.doubleValue>(self.bankModel.eachPrice.doubleValue*10000)) {
            [SpringAlertView showMessage:@"充值金额不能大于单笔限额！"];
            return;
        }
    }
    if (self.bankModel) {
        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskAll];
        @weakify(self)
        self.operation =[NetWorkOperation SendRequestWithMethods:@"transactionSave" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"price":self.rechargeMoney.text,@"type":@(1),@"channel":@(2),@"bankName":self.bankModel.bankName} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            RechargeOrWithdrawSuccessVC *buyVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([RechargeOrWithdrawSuccessVC class])];
            buyVc.currentType=1;
            GestureNavigationController *navc=[[GestureNavigationController alloc]initWithRootViewController:buyVc];
            [buyVc setCloseDown:^{
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:navc animated:YES completion:nil];
            [BaseIndicatorView hide];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [SpringAlertView showMessage:errorDescription];
        }];
    }else{
        [SpringAlertView showMessage:@"充值信息获取错误，请重新刷新页面"];
    }
}

-(void)ReachchangeButtonStatus{
    self.rechargeBtn.enabled = YES;
}

-(void)setRechargeMoney:(LimitTextField *)rechargeMoney{
    _rechargeMoney=rechargeMoney;
    @weakify(self)
    [[_rechargeMoney rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self validationRecharge];
    }];
}

- (IBAction)clickKFBtn:(id)sender {
    ServiceCenterVC *serviceVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ServiceCenterVC class])];
    [self.navigationController pushViewController:serviceVc animated:YES];
}

-(void)validationRecharge{
    if (self.rechargeMoney.success) {
        self.rechargeBtn.enabled=YES;
        [self.rechargeBtn setBackgroundColor:BtnColor];
    }else{
        self.rechargeBtn.enabled=NO;
        [self.rechargeBtn setBackgroundColor:BtnUnColor];
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
