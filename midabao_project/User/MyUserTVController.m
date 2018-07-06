//
//  MyUserTVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyUserTVController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "EnterUserView.h"
#import "LoginNavigationVController.h"
#import "RechargeVController.h"
#import "WithdrawVController.h"
#import "AccountpropertyVC.h"
#import "MyInsertVController.h"
#import "MyCenterVController.h"
#import "ReturnMoneyPlayVController.h"

#import "MyCouponVController.h"
#import "CapitalDetailVController.h"
#import "InvitefriendVController.h"

#import "SignListVController.h"
#import "UserInfoManager.h"
#import "UserInfoModel.h"
#import "NSString+ExtendMethod.h"
#import "GuideSetexchangePwdVC.h"
#import "AddBankVController.h"
#import "UILabel+Format.h"
#import "AddBankHaveNameVC.h"
#import "userTVCell.h"
#import "SignVController.h"
@interface MyUserTVController ()
@property (strong, nonatomic) IBOutlet UITableView *userTableview;
@property (weak, nonatomic) IBOutlet UIView *AccountpropertyView;
@property (weak, nonatomic) IBOutlet UILabel *myMoney;
@property (weak, nonatomic) IBOutlet UILabel *earningsLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UIButton *seemoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *myInsertLab;
@property (weak, nonatomic) IBOutlet UILabel *huikuanLab;
@property (weak, nonatomic) IBOutlet UILabel *ruponNumLab;
@property (weak, nonatomic) IBOutlet UILabel *jifengLab;
@property (weak, nonatomic) IBOutlet UIButton *reachBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (nonatomic,strong)EnterUserView *enterUserView;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)UserInfoModel *usermodel;
@end

@implementation MyUserTVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.extendedLayoutIncludesOpaqueBars=YES;
//    [self hideNavigationBar];
    
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.coverView.alpha = 0;
    if (![UserInfoManager shareUserManager].logined) {
        [self.view addSubview:self.enterUserView];
        [self.enterUserView showView];
        self.myMoney.text=!self.seemoneyBtn.selected?@"0.00":@"****";
        self.earningsLab.text=!self.seemoneyBtn.selected?@"0.00":@"****";
        self.balanceLab.text=!self.seemoneyBtn.selected?@"0.00":@"****";
        self.myInsertLab.text=!self.seemoneyBtn.selected?@"0.00":@"****";
        self.huikuanLab.text=@"";
        self.ruponNumLab.text=@"0";
        self.jifengLab.text=@"0";
        self.jifengLab.textColor=RGB(0x999999);
    }else{
        [self.enterUserView hiddenView];
        self.seemoneyBtn.selected=[UserInfoManager shareUserManager].ishideproperty;
        [self requestDate];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}
#pragma mark --获取用户信息
-(void)requestDate{
    dispatch_async(dispatch_queue_create(0, 0), ^{
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"userInfo" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            UserInfoModel *model=[[UserInfoModel alloc]initWithDictionary:result[RESULT_DATA][@"user"]];
            self.usermodel=model;
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                [self updataMyUserInfo];
            });
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [SpringAlertView showMessage:errorDescription];
        }];
        
    });           // 子线程执行任务（比如获取较大数据）
    

}
-(void)updataMyUserInfo {
    [[UserInfoManager shareUserManager]updateUserInfo:@{Key_Mobile:self.usermodel.phone,Key_RealName:self.usermodel.reserveName,Key_Idcard:self.usermodel.identityard,Key_Trade_Password_State:self.usermodel.isSetPassword,Key_Bankcard_State:self.usermodel.isSetBank,Key_Sign_State:self.usermodel.isSign,Key_Invest_State:self.usermodel.isInvest,Key_Profit:self.usermodel.profit,Key_EstProfit:self.usermodel.estimateProfit,Key_TotalAss:self.usermodel.totalAssets,Key_Balance:self.usermodel.balance,Key_WithdrawPrice:self.usermodel.withdrawalsPrice,Key_InvestPrice:self.usermodel.investmentPrice}];
    if (![self.usermodel.identityard isEqualToString:@""]&&self.usermodel.identityard!=nil) {
        //已经实名
        [[UserInfoManager shareUserManager].userInfo didCertifiedState:YES];
    }
    if([UserInfoManager shareUserManager].logined&&!self.seemoneyBtn.selected){
        [self.myMoney floatformatNumber:self.usermodel.totalAssets andSubText:@""];
        [self.earningsLab floatformatNumber:self.usermodel.profit andSubText:@""];
        [self.balanceLab floatformatNumber:self.usermodel.balance andSubText:@""];
        if (![self.usermodel.isInvest boolValue]) {
            self.myInsertLab.text=@"立即投资";
        }else{
            [self.myInsertLab floatformatNumber:self.usermodel.investmentPrice andSubText:@""];
        }
        
    }else{
        self.myMoney.text=@"****";
        self.earningsLab.text=@"****";
        self.balanceLab.text=@"****";
        self.myInsertLab.text=@"****";
        if (![UserInfoManager shareUserManager].logined) {
            self.myInsertLab.text=@"立即投资";
        }
        
    }
    NSString *huikuan=[NSString stringWithFormat:@"本周有%@笔回款",self.usermodel.repCount];
    self.huikuanLab.attributedText=[huikuan changeAttributeStringWithAttribute:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} Range:NSMakeRange(3, self.usermodel.repCount.length)];
    self.ruponNumLab.text=self.usermodel.couponerCount;
    if (![self.usermodel.isSign boolValue]) {
        self.jifengLab.text=@"签到";
        self.jifengLab.textColor=RGB(0xFF7F1B);
    }else{
        self.jifengLab.text=self.usermodel.integ;
        self.jifengLab.textColor=RGB(0x999999);
    }
    

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AccountpropertyClick)];
    [self.AccountpropertyView addGestureRecognizer:tap];
    @weakify(self)
    self.enterUserView.EnterUser = ^{
        //登录
        @strongify(self)
        [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
    };
    self.myMoney.font=[UIFont fontWithName:@"SFUIText-Medium" size:36];
    self.earningsLab.font=[UIFont fontWithName:@"SFUIText-Regular" size:18];
    self.balanceLab.font=[UIFont fontWithName:@"SFUIText-Regular" size:18];
    self.myInsertLab.font=[UIFont fontWithName:@"SFUIText-Regular" size:14];
    [self.reachBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.withdrawBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
}
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = RGBA(0x000000, 0.15);
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.backgroundColor = [UIColor whiteColor];
    } completion:nil];
}
#pragma mark --查看金额
- (IBAction)seeMyMoneyClick:(id)sender {
    UIButton *btn=sender;
    btn.selected=!btn.selected;
    [[UserInfoManager shareUserManager].userInfo ddiSaveMypropertyHideState:btn.selected];
    if (!btn.selected) {
        [self.myMoney floatformatNumber:self.usermodel.totalAssets andSubText:@""];
        [self.earningsLab floatformatNumber:self.usermodel.profit andSubText:@""];
        [self.balanceLab floatformatNumber:self.usermodel.balance andSubText:@""];
        [self.myInsertLab floatformatNumber:self.usermodel.investmentPrice andSubText:@""];
    }else{
        self.myMoney.text=@"****";
        self.earningsLab.text=@"****";
        self.balanceLab.text=@"****";
        self.myInsertLab.text=@"****";
        if (![UserInfoManager shareUserManager].logined) {
            self.myInsertLab.text=@"立即投资";
        }
    }
}
#pragma mark --点击进入个人中心
- (IBAction)clickCenterBtn:(id)sender {
    if (![UserInfoManager shareUserManager].logined) {
        [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        return;
    }
    MyCenterVController *centerVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([MyCenterVController class])];
    [self.navigationController pushViewController:centerVc animated:YES];
}
#pragma mark ---查看我的账户资产详情
-(void)AccountpropertyClick{
    AccountpropertyVC *aproVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AccountpropertyVC class])];
    [self.navigationController pushViewController:aproVc animated:YES];
}
- (IBAction)RechargeClick:(UIButton *)sender {
    
    if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//没有设置交易密码
        [self goRealNameAndBingBank:@"您还未实名认证，请先绑定银行卡进行实名认证"];
        return;
    }else if (![UserInfoManager shareUserManager].userInfo.bankcardstate){//没有绑定银行卡
        [self goRealNameAndBingBank:@"您还未绑定银行卡，请先绑定银行卡"];
        return;
    }
    RechargeVController *rechVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([RechargeVController class])];
    [self.navigationController pushViewController:rechVc animated:YES];
}
- (IBAction)WithdrawClick:(UIButton *)sender {

    if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//没有设置交易密码
        [self goRealNameAndBingBank:@"您还未实名认证，请先绑定银行卡进行实名认证"];
        return;
    }else if (![UserInfoManager shareUserManager].userInfo.bankcardstate){//没有绑定银行卡
        [self goRealNameAndBingBank:@"您还未绑定银行卡，请先绑定银行卡"];
        return;
    }
    WithdrawVController *rechVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([WithdrawVController class])];
    [self.navigationController pushViewController:rechVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section==0?1:3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 80;
    }
    return 0.1;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return (74+44+UISCREEN_WIDTH*200/375);
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, Margin_Big_Distance, 0, 0);
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section==0?0.1:Margin_Normal_Distance;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    if (indexPath.section==1&&indexPath.row==0) {//我的投资
        if (![self.usermodel.isInvest boolValue]) {//去投资
            self.tabBarController.selectedIndex = 1;
        }else{
            MyInsertVController *insertVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([MyInsertVController class])];
            insertVc.userModel=self.usermodel;
            [self.navigationController pushViewController:insertVc animated:YES];
        }
    
    }else if (indexPath.section==1&&indexPath.row==1){//回款计划
        ReturnMoneyPlayVController *returnVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ReturnMoneyPlayVController class])];
        [self.navigationController pushViewController:returnVc animated:YES];
    }else if (indexPath.section==1&&indexPath.row==2){//资金明细
        CapitalDetailVController *cpitalVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([CapitalDetailVController class])];
        [self.navigationController pushViewController:cpitalVc animated:YES];
    }else if (indexPath.section==2&&indexPath.row==0){//优惠券
        MyCouponVController *couponVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([MyCouponVController class])];
        [self.navigationController pushViewController:couponVc animated:YES];
    }else if (indexPath.section==2&&indexPath.row==1){//我的积分
        SignVController *signVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SignVController class])];
        [self.navigationController pushViewController:signVc animated:YES];
    }else if (indexPath.section==2&&indexPath.row==2){//邀请好友
        InvitefriendVController *inviteVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([InvitefriendVController class])];
        [self.navigationController pushViewController:inviteVc animated:YES];
    }
}

-(void)goRealNameAndBingBank:(NSString *)message{
    [AlertViewManager showInViewController:self title:@"温馨提示" message:message clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//如果没有设置交易密码的时候先进行设置交易密码
                GuideSetexchangePwdVC *pwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetexchangePwdVC class])];
                [self.navigationController pushViewController:pwd animated:YES];
            }else if(![UserInfoManager shareUserManager].userInfo.certifierstate){//没有实名认证
                AddBankVController *addBank=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AddBankVController class])];
                [self.navigationController pushViewController:addBank animated:YES];
            }else{//实名认证
                AddBankHaveNameVC *addBank=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AddBankHaveNameVC class])];
                [self.navigationController pushViewController:addBank animated:YES];
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}
-(EnterUserView *)enterUserView{
    if (!_enterUserView) {
        _enterUserView=[[EnterUserView alloc]initUserViewWithframe:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-49+SYS_TABBARSHDOWHEIGHT)];
    }
    return _enterUserView;
}
-(void)setUserTableview:(UITableView *)userTableview{
    _userTableview =userTableview;
    _userTableview.allowsMultipleSelection = YES;
    _userTableview.tableFooterView=[[UIView alloc]init];
#ifdef __IPHONE_11_0
    if ([_userTableview respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _userTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    [_userTableview registerNib:[UINib nibWithNibName:NSStringFromClass([userTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([userTVCell class])];
//    _userTableview.estimatedRowHeight=44;
//    _userTableview.rowHeight=UITableViewAutomaticDimension;
//    _userTableview.sectionFooterHeight = 0;
}


@end
