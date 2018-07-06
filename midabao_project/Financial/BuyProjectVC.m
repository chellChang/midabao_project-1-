

//
//  BuyProjectVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/10.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BuyProjectVC.h"
#import "DiscountCouponVC.h"
#import "MJRefresh.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
#import "couponViewModel.h"
#import "couponrModel.h"
#import "UILabel+Format.h"
#import "BuySuccessVController.h"
#import "GestureNavigationController.h"
#import "RechargeVController.h"
#import "WebVC.h"
@interface BuyProjectVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *bankscrollview;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *addrateLab;
@property (weak, nonatomic) IBOutlet UILabel *limtDay;
@property (weak, nonatomic) IBOutlet UILabel *startMoney;
@property (weak, nonatomic) IBOutlet UILabel *voteMoney;
@property (weak, nonatomic) IBOutlet UILabel *huankuanType;
@property (weak, nonatomic) IBOutlet UILabel *voteMyMoney;
@property (weak, nonatomic) IBOutlet UILabel *yinfuMoney;
@property (weak, nonatomic) IBOutlet UILabel *exportMoney;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *couponNumber;
@property (weak, nonatomic) IBOutlet UITextField *investMoney;
@property (nonatomic,strong)NetWorkOperation *operation;
@property (copy,nonatomic)NSString *voteMoneystr;//剩余可投金额
@property (copy,nonatomic)NSString *voteMymoneystr;//用户余额
@property (strong,nonatomic)couponViewModel *couponViewmodel;
@property (assign,nonatomic)NSInteger initialcouponNum;
@property (assign,nonatomic)NSInteger changecouponNum;
@property (copy,nonatomic)NSString *couponId;//使用优惠券id
@end

@implementation BuyProjectVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [self.couponViewmodel.operation cancelFetchOperation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bankscrollview.mj_header beginRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.bankscrollview.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"projectconfirm" params:@{@"projectId":self.projectModel.projectId,@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [self.bankscrollview.mj_header endRefreshing];
            [BaseIndicatorView hide];
            [self refirshUIwithData:result[RESULT_DATA]];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.bankscrollview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    
    [self requestcouponData];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
            [self dealwithCouponNumber];
    }];
    self.couponId=@"";
    [self validationBuyBtn];
        // Do any additional setup after loading the view.
}

-(void)requestcouponData{
    [self.couponViewmodel fetchFirstPageWithParams:@{@"projectId":self.projectModel.projectId,@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
    }];
}
-(void)dealwithCouponNumber{
    if ([self.voteMoneystr doubleValue]<[self.investMoney.text doubleValue]) {//如果输入金额大于剩余可投的时候
        self.investMoney.text=self.voteMoneystr;
    }
    if ([self.investMoney.text doubleValue]>[self.voteMymoneystr doubleValue]) {//如果投资的金额大于我的余额的时候
        [self.submitBtn setTitle:[NSString stringWithFormat:@"余额不足,需充值%.0f元",[self.investMoney.text doubleValue]-[self.voteMymoneystr doubleValue]] forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    }
    self.yinfuMoney.text=[NSString stringWithFormat:@"%.2f",[self.investMoney.text doubleValue]];
    self.exportMoney.text=[self.investMoney.text delacalculateDecimalNumberWithString:self.projectModel.dayProfit];
    self.couponId=@"";
    
    if (self.investMoney.text!=nil&&![self.investMoney.text isEqualToString:@""]&&![self.investMoney.text isKindOfClass:[NSNull class]]) {
        NSInteger index=0;
        if (self.couponViewmodel.allModels.count>0&&self.initialcouponNum>0) {
            for (int i=0; i<self.couponViewmodel.allModels.count; i++) {
                couponrModel *itemViewModel = self.couponViewmodel.allModels[i];
                if (itemViewModel.useStatus==1&&itemViewModel.isAva==1) {//未使用和可用的状态下才可以
                    if (itemViewModel.couponType==2) {//满减券
                        if (itemViewModel.investPriceUp<=[self.investMoney.text integerValue]) {
                            index++;
                        }
                    }else{
                        index++;
                    }
                }
                
            }
            if(index!=0){
                self.couponNumber.text=[NSString stringWithFormat:@"%ld张优惠券可用",index];
                self.couponNumber.textColor=RGB(0xFF2C2C);
                self.couponNumber.font=[UIFont systemFontOfSize:14];
                self.changecouponNum=index;
                self.couponNumber.layer.masksToBounds=NO;
                self.couponNumber.layer.cornerRadius=0;
                self.couponNumber.backgroundColor=[UIColor clearColor];
            }else if (index==0){
                self.couponNumber.textColor=RGB(0x999999);
                self.couponNumber.text=@"无优惠券可用";
                self.couponNumber.font=[UIFont systemFontOfSize:16];
                self.changecouponNum=0;
                self.couponNumber.layer.masksToBounds=NO;
                self.couponNumber.layer.cornerRadius=0;
                self.couponNumber.backgroundColor=[UIColor clearColor];
            }
        }else{
            self.couponNumber.textColor=RGB(0x999999);
            self.couponNumber.text=@"无优惠券可用";
            self.couponNumber.font=[UIFont systemFontOfSize:16];
            self.changecouponNum=0;
            self.couponNumber.layer.masksToBounds=NO;
            self.couponNumber.layer.cornerRadius=0;
            self.couponNumber.backgroundColor=[UIColor clearColor];
        }
    }else{
        if(self.initialcouponNum!=0){
            self.couponNumber.text=[NSString stringWithFormat:@"%ld张优惠券可用",self.initialcouponNum];
            self.couponNumber.textColor=RGB(0xFF2C2C);
            self.couponNumber.font=[UIFont systemFontOfSize:14];
            self.changecouponNum=self.initialcouponNum;
            self.couponNumber.layer.masksToBounds=NO;
            self.couponNumber.layer.cornerRadius=0;
            self.couponNumber.backgroundColor=[UIColor clearColor];
        }else if (self.initialcouponNum==0){
            self.couponNumber.textColor=RGB(0x999999);
            self.couponNumber.text=@"无优惠券可用";
            self.couponNumber.font=[UIFont systemFontOfSize:16];
            self.changecouponNum=0;
            self.couponNumber.layer.masksToBounds=NO;
            self.couponNumber.layer.cornerRadius=0;
            self.couponNumber.backgroundColor=[UIColor clearColor];
        }
    }
     [self validationBuyBtn];
    
    
}
-(void)refirshUIwithData:(NSDictionary *)result{
    self.projectName.text=self.projectModel.proName;
    self.rateLab.text=[NSString stringWithFormat:@"%.1f%%",self.projectModel.interestRate];
    self.addrateLab.hidden=self.projectModel.addInterestRate?NO:YES;
    self.addrateLab.text=self.projectModel.addInterestRate?[NSString stringWithFormat:@"+%.1f%%",self.projectModel.addInterestRate]:@"";
    NSString *limtType=self.projectModel.termCompany==1?@"天":@"个月";
    NSString *limtDay=[NSString stringWithFormat:@"%ld%@",self.projectModel.term,limtType];
    self.limtDay.attributedText=[limtDay changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} Range:NSMakeRange(limtDay.length-limtType.length, limtType.length)];
    NSString *eachStr=[NSString stringWithFormat:@"%ld元",self.projectModel.eachAmount];
    
    self.startMoney.attributedText=[eachStr changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} Range:NSMakeRange(eachStr.length-1, 1)];
    
//    self.voteMoney.attributedText=[votePrice changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} Range:NSMakeRange(votePrice.length-1, 1)];
    
    NSString *str1=[NSString stringWithFormat:@"%@", [CommonTools convertToStringWithObject:result[@"votePrice"]]];
    NSNumberFormatter *formatter1=[[NSNumberFormatter alloc]init];
    formatter1.numberStyle=NSNumberFormatterDecimalStyle;
    [formatter1 setPositiveFormat:@"###,##0"];
    NSString *votepricstr=[NSString stringWithFormat:@"%@元",[formatter1 stringFromNumber:[NSNumber numberWithDouble:[str1 doubleValue]]]];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:votepricstr];
    [string1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:16]} range:NSMakeRange(0,votepricstr.length-1)];
    [string1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:11]} range:NSMakeRange(votepricstr.length-1,1)];
    self.voteMoney.attributedText=string1;
    switch (self.projectModel.mode) {
        case 1:
            self.huankuanType.text=@"一次性还本付息";
            break;
        case 2:
            self.huankuanType.text=@"按月还息，到期还本";
            break;
        case 3:
            self.huankuanType.text=@"等额本息";
            break;
        default:
            self.huankuanType.text=@"";
            break;
    }
    self.voteMoneystr=[CommonTools convertToStringWithObject:result[@"votePrice"]];
    self.voteMymoneystr=[CommonTools convertToStringWithObject:result[@"userBalance"]];
    NSString *str=[NSString stringWithFormat:@"%@",[CommonTools convertFoloatToStringWithObject:result[@"userBalance"]]];
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"###,##0.00"];
    self.voteMyMoney.font=[UIFont fontWithName:@"SFUIText-Regular" size:14];
    self.voteMyMoney.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
    if ([self.couponId isEqualToString:@""]&&[self.investMoney.text integerValue]==0) {//当优惠券的ID为空的时候，没有选择优惠券
        self.initialcouponNum=[[CommonTools convertFoloatToStringWithObject:result[@"couponrCount"]] integerValue];
        if (self.initialcouponNum>0) {
            self.couponNumber.text=[NSString stringWithFormat:@"%ld张优惠券可用",self.initialcouponNum];
            self.couponNumber.textColor=RGB(0xFF2C2C);
            self.couponNumber.font=[UIFont systemFontOfSize:14];
            self.changecouponNum=self.initialcouponNum;
            self.couponNumber.layer.masksToBounds=NO;
            self.couponNumber.layer.cornerRadius=0;
            self.couponNumber.backgroundColor=[UIColor clearColor];
        }else{
            self.couponNumber.textColor=RGB(0x999999);
            self.couponNumber.text=@"无优惠券可用";
            self.couponNumber.font=[UIFont systemFontOfSize:16];
            self.changecouponNum=0;
            self.couponNumber.layer.masksToBounds=NO;
            self.couponNumber.layer.cornerRadius=0;
            self.couponNumber.backgroundColor=[UIColor clearColor];
        }
    }
    if ([self.investMoney.text doubleValue]>[self.voteMymoneystr doubleValue]) {//如果投资的金额大于我的余额的时候
        [self.submitBtn setTitle:[NSString stringWithFormat:@"余额不足,需充值%.0f元",[self.investMoney.text doubleValue]-[self.voteMymoneystr doubleValue]] forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    }
}

- (IBAction)clickInvestXY:(id)sender {
    WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/contract.html"];
    web.needPopAnimation=YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)chooseCouponClick:(id)sender {
    DiscountCouponVC *couponVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([DiscountCouponVC class])];
    couponVc.projectId=self.projectModel.projectId;
    couponVc.couponIds=self.couponId;
    if (self.investMoney.text!=nil&&![self.investMoney.text isEqualToString:@""]&&![self.investMoney.text isKindOfClass:[NSNull class]]) {
        couponVc.currentMoney=[self.investMoney.text integerValue];
    }else{
        couponVc.currentMoney=-1;
    }
    @weakify(self)
    couponVc.usedCoupon = ^(NSString *str,couponrModel *model) {
        @strongify(self)
        if (str&&![str isEqualToString:@""]) {
            self.couponNumber.text=str;
            self.couponId=model.couponrId;
            self.couponNumber.textColor=RGB(0xffffff);
            self.couponNumber.font=[UIFont systemFontOfSize:12];
            self.couponNumber.layer.masksToBounds=YES;
            self.couponNumber.layer.cornerRadius=2;
            self.couponNumber.backgroundColor=RGB(0xFF2C2C);
            if (model.couponType==1) {//加息券
                self.yinfuMoney.text=[NSString stringWithFormat:@"%.2f",[self.investMoney.text doubleValue]];
                NSString *jiaxiSY=[NSString stringWithFormat:@"%.2f",model.couponPrice/100.0/365.0*model.day*[self.investMoney.text doubleValue]];
                self.exportMoney.text=[NSString stringWithFormat:@"%@+%@",[self.investMoney.text delacalculateDecimalNumberWithString:self.projectModel.dayProfit],jiaxiSY];
            }else if (model.couponType==2){//满减券
                self.yinfuMoney.text=[NSString stringWithFormat:@"%.2f",([self.investMoney.text doubleValue]-model.couponPrice)];
                self.exportMoney.text=[self.investMoney.text delacalculateDecimalNumberWithString:self.projectModel.dayProfit];
            }
        }else{
            if (self.changecouponNum) {
                self.couponNumber.text=[NSString stringWithFormat:@"%ld张优惠券可用",self.changecouponNum];
                self.couponNumber.textColor=RGB(0xFF2C2C);
                self.couponNumber.font=[UIFont systemFontOfSize:14];
                self.couponNumber.layer.masksToBounds=NO;
                self.couponNumber.layer.cornerRadius=0;
                self.couponNumber.backgroundColor=[UIColor clearColor];
            }else{
                self.couponNumber.textColor=RGB(0x999999);
                self.couponNumber.text=@"无优惠券可用";
                self.couponNumber.font=[UIFont systemFontOfSize:16];
                self.couponNumber.layer.masksToBounds=NO;
                self.couponNumber.layer.cornerRadius=0;
                self.couponNumber.backgroundColor=[UIColor clearColor];
            }
            self.couponId=@"";
            self.yinfuMoney.text=[NSString stringWithFormat:@"%.2f",[self.investMoney.text doubleValue]];
            self.exportMoney.text=[self.investMoney.text delacalculateDecimalNumberWithString:self.projectModel.dayProfit];
        }
        
    };
    couponVc.cancouponnum=self.changecouponNum;
    [self.navigationController pushViewController:couponVc animated:YES];
}
#pragma mark  --点击全部投资
- (IBAction)investAllMoneyClick:(id)sender {
    if ([self.voteMoneystr doubleValue]>[self.voteMymoneystr doubleValue]) {//如果剩余可投大于用户余额
        self.investMoney.text=[NSString stringWithFormat:@"%ld",[self.voteMymoneystr integerValue]-([self.voteMymoneystr integerValue]%self.projectModel.eachAmount)];
    }else if ([self.voteMoneystr doubleValue]<=[self.voteMymoneystr doubleValue]){//如果剩余可投小于等于用户余额
        self.investMoney.text=self.voteMoneystr;
    }
    [self dealwithCouponNumber];

}
#pragma mark --点击确认购买
- (IBAction)submitBtnClick:(id)sender {
    [self.view endEditing:YES];
    UIButton *btn=(UIButton *)sender;
    if (![btn.titleLabel.text isEqualToString:@"确认购买"]) {
        RechargeVController *rechVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([RechargeVController class])];
        rechVc.needreachMoney=[NSString stringWithFormat:@"%ld",[self.investMoney.text integerValue]-[self.voteMymoneystr integerValue]];
        [self.navigationController pushViewController:rechVc animated:YES];
        return;
    }
    if ([self.investMoney.text doubleValue]<self.projectModel.eachAmount) {//小于起投金额
        [SpringAlertView showMessage:@"购买金额必须大于起投金额！"];
        return;
    }
    if ([self.investMoney.text integerValue]%self.projectModel.eachAmount!=0) {
        [AlertViewManager showInViewController:self title:@"提示" message:@"购买金额必须是起投金额的整数倍！" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        return;
    }
    NSDictionary *parmatdic;
    if(![self.couponId isEqualToString:@""]&&self.couponId) {
        parmatdic=@{@"projectId":self.projectModel.projectId,@"couponrId":self.couponId,@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"purchasePrice":self.investMoney.text,@"source":@1,@"payPrice":self.yinfuMoney.text};
    }else{
        parmatdic=@{@"projectId":self.projectModel.projectId,@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"purchasePrice":self.investMoney.text,@"source":@1,@"payPrice":self.yinfuMoney.text};
    }
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"projectpurchase" params:parmatdic success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        //购买成功
        BuySuccessVController *buyVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([BuySuccessVController class])];
        GestureNavigationController *navc=[[GestureNavigationController alloc]initWithRootViewController:buyVc];
        [buyVc setCloseDown:^{
            @strongify(self)
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        if (self.projectModel.mode==1) {//一次性还本付息
            buyVc.showtype=1;
        }else{
            buyVc.showtype=2;
        }
        [self presentViewController:navc animated:YES completion:nil];
        [BaseIndicatorView hide];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(couponViewModel *)couponViewmodel{
    if (!_couponViewmodel) {
        _couponViewmodel =[[couponViewModel alloc]init];
    }
    return _couponViewmodel;
}

-(void)validationBuyBtn{
    if (![self.investMoney.text isEqualToString:@""]&&self.investMoney.text) {
        self.submitBtn.enabled=YES;
        [self.submitBtn setBackgroundColor:BtnColor];
    }else{
        self.submitBtn.enabled=NO;
        [self.submitBtn setBackgroundColor:BtnUnColor];
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
