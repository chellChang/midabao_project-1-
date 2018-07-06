
//
//  ProjectDetailVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/9.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectDetailVC.h"
#import "UserInfoManager.h"
#import "productInfoView.h"
#import "productDetailView.h"
#import "BuyProjectVC.h"
#import "CalculateView.h"
#import "projectDetailModel.h"
#import "LoginNavigationVController.h"
#import "GuideSetexchangePwdVC.h"
#import "AddBankVController.h"
#import "AddBankHaveNameVC.h"
@interface ProjectDetailVC ()<ProductViewDelegate,productInfoDelegate>
@property (weak, nonatomic) IBOutlet UIButton *calculateBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bankScrollview;
@property (weak, nonatomic) IBOutlet UIButton *rightBuyBtn;
@property(nonatomic,strong)CalculateView *calculateView;
@property (nonatomic,strong)NetWorkOperation *operation;
@property(nonatomic,strong)NSMutableArray *pullViews;
@property (nonatomic,strong)projectDetailModel *proModel;
@property (strong,nonatomic)productDetailView *projectDetview;
@property (strong,nonatomic)productInfoView *projectInfoView;
@end

@implementation ProjectDetailVC
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.operation cancelFetchOperation];
    [self.projectDetview rockenTimeWithState:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bankScrollview.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    self.extendedLayoutIncludesOpaqueBars=NO;
    [self.view bringSubviewToFront:self.calculateBtn];
    [self.projectDetview rockenTimeWithState:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    // 设置CGRectZero从导航栏下开始计算
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    self.bankScrollview.pagingEnabled=YES;
    self.bankScrollview.showsHorizontalScrollIndicator=NO;
    self.bankScrollview.scrollEnabled=NO;
    self.bankScrollview.contentSize=CGSizeMake(UISCREEN_WIDTH,(UISCREEN_HEIGHT-64-49)*2);
    self.projectDetview=[[productDetailView alloc]initProductDetailViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-64-49)];
    if (self.projectDetview.mainViewHeight.constant<UISCREEN_HEIGHT-64-49) {
         self.projectDetview.mainViewHeight.constant=UISCREEN_HEIGHT-64-49;
    }
    [self.bankScrollview addSubview:self.projectDetview];
    self.projectDetview.delegate=self;
    self.projectInfoView=[[productInfoView alloc]initProductInfoViewWithFrame:CGRectMake(0, UISCREEN_HEIGHT-64-49, UISCREEN_WIDTH, UISCREEN_HEIGHT-64-49)];
    @weakify(self)
    self.projectDetview.refirshCurrentState = ^{
        @strongify(self)
        self.rightBuyBtn.enabled=NO;
        self.rightBuyBtn.backgroundColor=BtnUnColor;
        [self.rightBuyBtn setTitle:@"已售罄" forState:UIControlStateNormal];
    };
    self.projectInfoView.contentHeightCos.constant=UISCREEN_HEIGHT-64-49;
    self.projectInfoView.delegate=self;
    [self.bankScrollview addSubview:self.projectInfoView];
    [self.pullViews addObject:self.projectDetview];
    [self.pullViews addObject:self.projectInfoView];
    [self requestData];
}
-(void)requestData{
    [BaseIndicatorView show];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"queryDetail" params:@{@"projectId":self.projectId} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        projectDetailModel *model=[projectDetailModel yy_modelWithJSON:result[RESULT_DATA][@"projectDetails"]];
        self.proModel=model;
        if (model.projectStatus!=5) {//已售罄或已流标
            self.rightBuyBtn.enabled=NO;
            self.rightBuyBtn.backgroundColor=BtnUnColor;
            if (model.projectStatus==7) {
                [self.rightBuyBtn setTitle:@"已流标" forState:UIControlStateNormal];
            }else{
                [self.rightBuyBtn setTitle:@"已售罄" forState:UIControlStateNormal];
            }
        }
        [self.projectDetview updataUiWithModel:self.proModel];
        [self.projectInfoView reloadWithModel:self.proModel];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}

-(NSMutableArray *)pullViews{
    if (!_pullViews) {
        _pullViews=[NSMutableArray arrayWithCapacity:0];
    }
    return _pullViews;
}
-(void)pullDownView{
    
    CGPoint contentOffset=self.bankScrollview.contentOffset;
    [self pullDownWithparamNumber:1 andContentOffset:contentOffset andCurrentIndex:0];
}
-(void)pullUpView{
    self.title=@"精选赎楼";
    self.calculateBtn.hidden= NO;
    CGPoint contentOffset=self.bankScrollview.contentOffset;
    [self pullDownWithparamNumber:-1 andContentOffset:contentOffset andCurrentIndex:1];
}
-(void)PullDownView:(productDetailView *)simView andPullType:(PullType)type{
    //获取当前的偏移量
    CGPoint contentOffset=self.bankScrollview.contentOffset;
    NSInteger index=[self.pullViews indexOfObject:simView];
    
    switch (type) {
        case pullTypeUp://上翻页
        {
            if (index!=0) {
                [self pullDownWithparamNumber:-1 andContentOffset:contentOffset andCurrentIndex:index];
            }
        }
            break;
        case pullTypeDown://下翻页
        {
            if (index!=self.pullViews.count-1) {
                self.title=self.projectDetview.projectName.text;
                self.calculateBtn.hidden=YES;
                [self pullDownWithparamNumber:1 andContentOffset:contentOffset andCurrentIndex:index];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark --滚动操作
-(void)pullDownWithparamNumber:(CGFloat)number andContentOffset:(CGPoint)point andCurrentIndex:(NSInteger)index{
    CGPoint contentOffset=point;
    contentOffset.y+=(number*(UISCREEN_HEIGHT-64-49));
    [self.bankScrollview setContentOffset:contentOffset animated:YES];
    
}
#pragma mark --立即购买
- (IBAction)rightByProjectClick:(id)sender {
    if (![UserInfoManager shareUserManager].logined) {
         [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        return;
    }
    if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//没有设置交易密码
        [self goRealNameAndBingBank:@"您还未实名认证，请先绑定银行卡进行实名认证"];
        return;
    }else if (![UserInfoManager shareUserManager].userInfo.bankcardstate){//没有绑定银行卡
        [self goRealNameAndBingBank:@"您还未绑定银行卡，请先绑定银行卡"];
        return;
    }
    BuyProjectVC *buyVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([BuyProjectVC class])];
    buyVc.projectModel=self.proModel;
    [self.navigationController pushViewController:buyVc animated:YES];
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
#pragma mark --点击计算器
- (IBAction)ClickCalculateBtn:(id)sender {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.calculateView.rato=self.proModel.dayProfit;
    switch (self.proModel.mode) {
        case 1:
            self.calculateView.type=@"一次性还本付息";
            break;
        case 2:
            self.calculateView.type=@"按月还息，到期还本";
            break;
        case 3:
            self.calculateView.type=@"等额本息";
            break;
        default:
            self.calculateView.type=@"等额本息";
            break;
    }

    [self.calculateView showInWindow:window];
}

-(CalculateView *)calculateView{
    if (!_calculateView) {
        _calculateView=[[CalculateView alloc]initCalculateViewWithframe:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    }
    return _calculateView;
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
