
//
//  UsedCouponVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UsedCouponVController.h"
#import "StateTableView.h"
#import "UsedCouponTVCell.h"
#import "couponViewModel.h"
#import "MJRefresh.h"
#import "UserInfoManager.h"
@interface UsedCouponVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *couponTabview;
@property (strong,nonatomic)couponViewModel *copViewModel;
@end

@implementation UsedCouponVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.couponTabview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.copViewModel.allModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsedCouponTVCell*cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UsedCouponTVCell class])];
    [cell configureUIWithData:self.copViewModel.allModels[indexPath.row]];
    return cell;
}
-(void)setCouponTabview:(StateTableView *)couponTabview{
    _couponTabview=couponTabview;
    _couponTabview.delegate=self;
    _couponTabview.dataSource=self;
    _couponTabview.estimatedRowHeight=130;
    _couponTabview.rowHeight=UITableViewAutomaticDimension;
    _couponTabview.sectionFooterHeight = 0;
    _couponTabview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_couponTabview registerNib:[UINib nibWithNibName:NSStringFromClass([UsedCouponTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UsedCouponTVCell class])];
    @weakify(self)
    _couponTabview.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.copViewModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"couponType":@(self.state),@"couponStatus":@0} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            [self.couponTabview.mj_header endRefreshing];
            self.couponTabview.type = 0 == self.copViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.couponTabview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.couponTabview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.couponTabview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.couponTabview.mj_header endRefreshing];
            self.couponTabview.type = 0 == self.copViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _couponTabview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.copViewModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"couponType":@(self.state),@"couponStatus":@0} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            [self.couponTabview.mj_footer endRefreshing];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.couponTabview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_couponTabview setClickCallBack:^{
        [_couponTabview.mj_header beginRefreshing];
    }];
}
-(couponViewModel *)copViewModel{
    if (!_copViewModel) {
        _copViewModel=[[couponViewModel alloc]init];
    }
    return _copViewModel;
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
