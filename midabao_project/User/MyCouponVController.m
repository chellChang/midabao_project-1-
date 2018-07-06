//
//  MyCouponVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyCouponVController.h"
#import "MyCouponView.h"
#import "HorizontalScrollView.h"
#import "ExclusiveButton.h"
#import "UsedCouponVController.h"
#import "UserInfoManager.h"
@interface MyCouponVController ()<UIScrollViewDelegate,MycouponViewDelegate>
@property (weak, nonatomic) IBOutlet HorizontalScrollView *contentView;
@property (strong, nonatomic) IBOutlet ExclusiveButton *chooseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWith;
@property (strong,nonatomic)MyCouponView *manjianCouponView;
@property (strong,nonatomic)MyCouponView *jiaxiCouponView;
@property (strong,nonatomic)MyCouponView *tiyanView;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation MyCouponVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    self.lineWith.constant=32;
    self.contentView.contentSubviews=@[self.manjianCouponView,self.jiaxiCouponView,self.tiyanView];
    [[self.contentView presentingSubview]beginRefresh];
    // Do any additional setup after loading the view.
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        
        self.lineX.constant = scrollView.contentOffset.x/3;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        if (scrollView.contentOffset.x==0) {
            [self.chooseBtn setButtonInvalid:[self.chooseBtn.invalidButton.superview viewWithTag:400]];
            self.lineWith.constant=32;
        }else if (scrollView.contentOffset.x==UISCREEN_WIDTH){
            [self.chooseBtn setButtonInvalid:[self.chooseBtn.invalidButton.superview viewWithTag:401]];
            self.lineWith.constant=48;
        }else {
            [self.chooseBtn setButtonInvalid:[self.chooseBtn.invalidButton.superview viewWithTag:402]];
            self.lineWith.constant=48;
        }
    }
}

#pragma mark --MyCouponView代理
// 使用优惠券
-(void)usdCoupoonWithcouponId:(NSString *)couponId andCurrentState:(NSInteger)state{
    if (state!=3) {
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{//使用体验金
        if (couponId!=nil&&![couponId isKindOfClass:[NSNull class]]) {
            [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskAll];
            self.operation =[NetWorkOperation SendRequestWithMethods:@"coupontiyanUse" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"couponrId":couponId} success:^(NSURLSessionTask *task, id result) {
                [BaseIndicatorView hide];
                self.tiyanView.needRefreshList=YES;
                [[self.contentView presentingSubview]beginRefresh];
                [SpringAlertView showMessage:@"使用体验金成功！"];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                [BaseIndicatorView hide];
                [SpringAlertView showMessage:errorDescription];
            }];
        }
        
    }
}

//查看过期的加息券
-(void)seeUsedCouponViewWithState:(NSInteger)state{
    UsedCouponVController *usedVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([UsedCouponVController class])];
    usedVc.state=state;
    switch (state) {
        case 1:
            usedVc.title=@"已使用和已失效的加息券";
            break;
        case 2:
            usedVc.title=@"已使用和已失效的的红包";
            break;
        case 3:
            usedVc.title=@"已使用和已失效的体验金";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:usedVc animated:YES];
}


-(void)setChooseBtn:(ExclusiveButton *)chooseBtn{
    _chooseBtn=chooseBtn;
    @weakify(self)
    _chooseBtn.invalidButtonDidChangeBlock = ^(UIButton *sender) {
        @strongify(self)
        self.contentView.contentOffset = CGPointMake((sender.tag - 400)*self.contentView.width, 0);
        self.lineX.constant=UISCREEN_WIDTH/3*(sender.tag-400);
        if (sender.tag==400) {
            self.lineWith.constant=32;
        }else if (sender.tag==401){
            self.lineWith.constant=48;
        }else if (sender.tag==402){
            self.lineWith.constant=48;
        }
        [[self.contentView presentingSubview]beginRefresh];
    };
}
-(MyCouponView *)manjianCouponView{
    if (!_manjianCouponView) {
        _manjianCouponView=[MyCouponView customViewWithState:2];
        _manjianCouponView.delegate=self;
    }
    return _manjianCouponView;
}
-(MyCouponView *)jiaxiCouponView{
    if (!_jiaxiCouponView) {
        _jiaxiCouponView=[MyCouponView customViewWithState:1];
        _jiaxiCouponView.delegate=self;
    }
    return _jiaxiCouponView;
}
-(MyCouponView *)tiyanView{
    if (!_tiyanView) {
        _tiyanView=[MyCouponView customViewWithState:3];
        _tiyanView.delegate=self;
    }
    return _tiyanView;
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
