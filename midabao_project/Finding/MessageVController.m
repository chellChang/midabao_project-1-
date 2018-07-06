
//
//  MessageVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MessageVController.h"
#import "StateTableView.h"
#import "MessageVCell.h"
#import "FindListViewModel.h"
#import "MJRefresh.h"
#import "WebVC.h"
#include "findListModel.h"
@interface MessageVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *messageTabView;
@property (strong,nonatomic)FindListViewModel *messageViewModel;
@end

@implementation MessageVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.messageTabView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageViewModel.allModels.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *topView=[[UIView alloc]init];
        topView.backgroundColor=RGB(0xF2F4F6);
        return topView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageVCell*cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageVCell class])];
    [cell configureUi:self.messageViewModel.allModels[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.messageViewModel.allModels.count>0) {
       
        findListModel *model=self.messageViewModel.allModels[indexPath.row];
         WebVC *web=[[WebVC alloc] initWithWebPath:model.url];
            web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}
-(void)setMessageTabView:(StateTableView *)messageTabView{
    _messageTabView=messageTabView;
    _messageTabView.delegate=self;
    _messageTabView.dataSource=self;
    _messageTabView.estimatedRowHeight=130;
    _messageTabView.rowHeight=UITableViewAutomaticDimension;
    _messageTabView.sectionFooterHeight = 0;
    _messageTabView.tableHeaderView.backgroundColor=RGB(0xF2F4F6);
    _messageTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_messageTabView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageVCell class])];
    @weakify(self)
    _messageTabView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.messageViewModel fetchFirstPageWithParams:@{@"findType":@"1"} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            self.messageTabView.type = 0 == self.messageViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.messageTabView.mj_header endRefreshing];
            [self.messageTabView reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.messageTabView.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.messageTabView.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            self.messageTabView.type = 0 == self.messageViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [self.messageTabView.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _messageTabView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.messageViewModel fetchNextPageWithParams:@{@"findType":@"1"} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.messageTabView.mj_footer endRefreshing];
            [self.messageTabView reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.messageTabView.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_messageTabView setClickCallBack:^{
        @strongify(self)
        [self.messageTabView.mj_header beginRefreshing];
    }];
}
-(FindListViewModel *)messageViewModel{
    if (!_messageViewModel) {
        _messageViewModel=[[FindListViewModel alloc]init];
    }
    return _messageViewModel;
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
