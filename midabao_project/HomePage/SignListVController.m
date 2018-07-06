
//
//  SignListVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "SignListVController.h"
#import "StateTableView.h"
#import "SignListTVCell.h"
#import "IntegralHistoryViewModel.h"
#import "MJRefresh.h"
#import "UserInfoManager.h"
@interface SignListVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *signlistTableview;
@property (strong,nonatomic)IntegralHistoryViewModel *viewModel;
@end

@implementation SignListVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.viewModel.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.signlistTableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.allModels.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignListTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SignListTVCell class])];
    if (self.viewModel.allModels.count-1==indexPath.row) {
        cell.bottomLinex.hidden=YES;
    }else{
        cell.bottomLinex.hidden=NO;
    }
    [cell configuiWithData:self.viewModel.allModels[indexPath.row]];
    return cell;
}
-(void)setSignlistTableview:(StateTableView *)signlistTableview{
    _signlistTableview=signlistTableview;
    _signlistTableview.delegate=self;
    _signlistTableview.dataSource=self;
    _signlistTableview.estimatedRowHeight=74;
    _signlistTableview.rowHeight=UITableViewAutomaticDimension;
    _signlistTableview.sectionFooterHeight = 0;
    [_signlistTableview registerNib:[UINib nibWithNibName:NSStringFromClass([SignListTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SignListTVCell class])];
    @weakify(self)
    _signlistTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            self.signlistTableview.type = 0 == self.viewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.signlistTableview.mj_header endRefreshing];
            [self.signlistTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.signlistTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.signlistTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            self.signlistTableview.type = 0 == self.viewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [self.signlistTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _signlistTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.viewModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [self.signlistTableview.mj_footer endRefreshing];
            [self.signlistTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [self.signlistTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_signlistTableview setClickCallBack:^{
        @strongify(self)
            [self.signlistTableview.mj_header beginRefreshing];
    }];
    
}
-(IntegralHistoryViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel=[[IntegralHistoryViewModel alloc]init];
    }
    return _viewModel;
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
