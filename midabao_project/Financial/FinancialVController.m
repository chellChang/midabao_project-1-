//
//  FinancialVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FinancialVController.h"
#import "MidabaoTabBar.h"
#import "StateTableView.h"
#import "ProductCell.h"
#import "projectListViewModel.h"
#import "MJRefresh.h"
#import "ProjectDetailVC.h"
#import "ProjectListModel.h"
@interface FinancialVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *productTableview;

@property (strong,nonatomic)projectListViewModel *projectViewModel;
@end

@implementation FinancialVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.productTableview.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.productTableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.projectViewModel.operation cancelFetchOperation];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.projectViewModel.allModels.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductCell class])];
    [cell configuiWithData:self.projectViewModel.allModels[indexPath.section]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProjectDetailVC *projectVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ProjectDetailVC class])];
    ProjectListModel *model=self.projectViewModel.allModels[indexPath.section];
    projectVc.projectId=model.projectId;
    projectVc.title=model.proTypeName;
    [self.navigationController pushViewController:projectVc animated:YES];
}
-(void)setProductTableview:(StateTableView *)productTableview{
    _productTableview=productTableview;
    _productTableview.delegate=self;
    _productTableview.dataSource=self;
    _productTableview.estimatedRowHeight=140;
    _productTableview.rowHeight=UITableViewAutomaticDimension;
    _productTableview.sectionFooterHeight = 0;
    _productTableview.allowsMultipleSelection = YES;
    [_productTableview registerNib:[UINib nibWithNibName:NSStringFromClass([ProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductCell class])];
    @weakify(self)
    _productTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.projectViewModel fetchFirstPageWithParams:nil success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            self.productTableview.type = 0 == self.projectViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.productTableview.mj_header endRefreshing];
            [self.productTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.productTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.productTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            self.productTableview.type = 0 == self.projectViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [self.productTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _productTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.projectViewModel fetchNextPageWithParams:nil success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [self.productTableview.mj_footer endRefreshing];
            [self.productTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [self.productTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_productTableview setClickCallBack:^{
      @strongify(self)
        [self.productTableview.mj_header beginRefreshing];
    }];
}
-(projectListViewModel *)projectViewModel{
    if (!_projectViewModel) {
        _projectViewModel=[[projectListViewModel alloc]init];
    }
    return _projectViewModel;
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
