//
//  MyInsertVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyInsertVController.h"
#import "HHHorizontalPagingView.h"
#import "InsertHeaderView.h"
#import "MyInsertSubTabView.h"
#import "InsertDetailVController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "investListViewModel.h"
#import "UserInfoManager.h"
#import "UILabel+Format.h"
@interface MyInsertVController ()<MyinsertSubViewDelegate>
@property (strong,nonatomic)HHHorizontalPagingView *pagingView;
@property (strong,nonatomic)InsertHeaderView *headerView;
@property (strong,nonatomic)NSMutableArray *buttonArr;
@property (strong,nonatomic)MyInsertSubTabView *allTabView;
@property (strong,nonatomic)MyInsertSubTabView *refundingTabView;
@property (strong,nonatomic)MyInsertSubTabView *raiseingTabView;
@property (strong,nonatomic)MyInsertSubTabView *settleTabView;
@property (strong,nonatomic)UIButton *leftbackBtn;
@property (assign,nonatomic)BOOL backgraoundblack;/**<yes是黑色*/
@property (strong,nonatomic)NetWorkOperation *operation;

@end

@implementation MyInsertVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.backgraoundblack) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.coverView.alpha = 0;
    self.navigationController.navigationBarHidden=NO;
    self.allTabView.Mydelelgate=self;
    self.refundingTabView.Mydelelgate=self;
    self.raiseingTabView.Mydelelgate=self;
    self.settleTabView.Mydelelgate=self;
    [self.view addSubview:self.pagingView];
    [self createCoustomLeftItem];
    [self.headerView.myprincipalMoney floatformatNumber:self.userModel.investmentPrice andSubText:@""];
    [self.headerView.daiearnings floatformatNumber:self.userModel.estimateProfit andSubText:@""];
    [self.headerView.yiearnings floatformatNumber:self.userModel.profit andSubText:@""];
    [self configureUIWithIndex:0];
    // Do any additional setup after loading the view.
}
-(void)createCoustomLeftItem{
    self.leftbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.leftbackBtn.backgroundColor = [UIColor clearColor];
    [self.leftbackBtn setImage:[UIImage imageNamed:@"backWhite"] /*imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]*/ forState:UIControlStateNormal];
    self.leftbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftbackBtn addTarget:self action:@selector(clcikBank) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftbackBtn];
    self.navigationItem.leftBarButtonItem = buttonItem;
}
-(void)clcikBank{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSelectRowWithID:(NSString *)projectId{
    InsertDetailVController *insertVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([InsertDetailVController class])];
    insertVc.investId=projectId;
    [self.navigationController pushViewController:insertVc animated:YES];
    
}
-(void)configureUIWithIndex:(NSInteger)index{
    if (index==0) {
        [self.allTabView firstRefirshUIWithView];
    }else if (index==1){
        [self.refundingTabView firstRefirshUIWithView];
    }else if (index==2){
        [self.raiseingTabView firstRefirshUIWithView];
    }else if (index==3){
        [self.settleTabView firstRefirshUIWithView];
    }
}

-(NSMutableArray *)buttonArr{
    if (!_buttonArr) {
        _buttonArr=[NSMutableArray arrayWithCapacity:0];
        NSArray *arr=@[@"全部",@"回款中",@"募集中",@"已结清"];
        for(int i = 0; i < 4; i++) {
            UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            segmentButton.titleLabel.font=[UIFont systemFontOfSize:16];
            [segmentButton setTitleColor:RGB(0x3379EA) forState:UIControlStateSelected];
            [segmentButton setTitleColor:RGB(0x999999) forState:UIControlStateNormal];
            [segmentButton setTitle:arr[i] forState:UIControlStateNormal];
            segmentButton.backgroundColor=[UIColor whiteColor];
//            [segmentButton setBackgroundImage:[UIImage imageNamed:@"icon_butBottomtransparent"] forState:UIControlStateNormal];
            segmentButton.adjustsImageWhenHighlighted = NO;
            [_buttonArr addObject:segmentButton];
        }
    }
    return _buttonArr;
}

-(HHHorizontalPagingView *)pagingView{
    if (!_pagingView) {
        _pagingView=[HHHorizontalPagingView pagingViewWithHeaderView:self.headerView headerHeight:220 segmentButtons:self.buttonArr segmentHeight:44 contentViews:@[self.allTabView, self.refundingTabView,self.raiseingTabView,self.settleTabView]];
        _pagingView.segmentTopSpace=64;
        _pagingView.magnifyTopConstraint=self.headerView.headViewTopCos;
        @weakify(self)
        _pagingView.scrollViewDidScrollBlock = ^(CGFloat offset) {
            @strongify(self)
            CGFloat alpha=1-((170-(offset+264))/170);//264是头部+segmentBtn的高度
            [self chanageNavigationBarAlpha:alpha];
            if (alpha<=0) {
                self.backgraoundblack=NO;
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
                [self.leftbackBtn setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
            }else if(alpha>0.6){
                self.backgraoundblack=YES;
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
                [self.leftbackBtn setImage:[UIImage imageNamed:NavigationBar_Back] forState:UIControlStateNormal];
            }
            self.navigationController.navigationBarHidden=NO;
        };
        _pagingView.clickEventViewsBlock = ^(UIView *eventView) {
            
        };
        _pagingView.pagingViewSwitchBlock = ^(NSInteger switchIndex) {
            @strongify(self)
                [self.pagingView setTopReirshUI];
                [self configureUIWithIndex:switchIndex];
        };
    }
    return _pagingView;
}


-(MyInsertSubTabView *)allTabView{
    if (!_allTabView) {
        _allTabView=[MyInsertSubTabView contentTableviewWithState:0];
    }
    return _allTabView;
}
-(MyInsertSubTabView *)refundingTabView{
    if (!_refundingTabView) {
        _refundingTabView=[MyInsertSubTabView contentTableviewWithState:1];
    }
    return _refundingTabView;
}
-(MyInsertSubTabView *)raiseingTabView{
    if (!_raiseingTabView) {
        _raiseingTabView=[MyInsertSubTabView contentTableviewWithState:2];
    }
    return _raiseingTabView;
}
-(MyInsertSubTabView *)settleTabView{
    if (!_settleTabView) {
        _settleTabView=[MyInsertSubTabView contentTableviewWithState:3];
    }
    return _settleTabView;
}
-(InsertHeaderView *)headerView{
    if (!_headerView) {
        _headerView=[[InsertHeaderView alloc]initCustomWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 220)];
    }
    return _headerView;
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
