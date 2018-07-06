
//
//  ReturnMoneyView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ReturnMoneyView.h"
#import "StateTableView.h"
#import "ReturnMoneyTVCell.h"
#import "MJRefresh.h"
#import "roalMoneyplayVModel.h"
#import "UserInfoManager.h"
@interface ReturnMoneyView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *contentTableview;
@property (strong,nonatomic)roalMoneyplayVModel *roalViewModel;
@property (assign,nonatomic)NSInteger currentState;
@end
@implementation ReturnMoneyView
+(instancetype)customViewWithState:(NSInteger)state{
    ReturnMoneyView *view=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    if ([view isMemberOfClass:[self class]]) {
        view.currentState=state;
        view.needRefreshList = YES;
        return view;
    }
    return nil;
}
- (void)beginRefresh {
    if (self.needRefreshList) {
        [self.contentTableview.mj_header beginRefreshing];
    }
}
- (void)stopRefreshing {
    
    [self.roalViewModel.operation cancelFetchOperation];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.roalViewModel.allModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReturnMoneyTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReturnMoneyTVCell class])];
    [cell configureUI:self.roalViewModel.allModels[indexPath.section]];
    return cell;
}

-(void)setContentTableview:(StateTableView *)contentTableview{
    _contentTableview=contentTableview;
    _contentTableview.delegate=self;
    _contentTableview.dataSource=self;
    _contentTableview.estimatedRowHeight=122;
    _contentTableview.rowHeight=UITableViewAutomaticDimension;
    _contentTableview.sectionFooterHeight = 0;
    [contentTableview registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnMoneyTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReturnMoneyTVCell class])];
    @weakify(self)
    contentTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
        [self.roalViewModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"repType":@(self.currentState)} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            self.needRefreshList = NO;
            self.contentTableview.type = 0 == self.roalViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.contentTableview.mj_header endRefreshing];
            [self.contentTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.contentTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.contentTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            self.contentTableview.type = 0 == self.roalViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [self.contentTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    contentTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
        [self.roalViewModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"repType":@(self.currentState)} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.contentTableview.mj_footer endRefreshing];
            [self.contentTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.contentTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [contentTableview setClickCallBack:^{
        @strongify(self)
        [self.contentTableview.mj_header beginRefreshing];
    }];
}
-(roalMoneyplayVModel *)roalViewModel{
    if (!_roalViewModel) {
        _roalViewModel=[[roalMoneyplayVModel alloc]init];
    }
    return _roalViewModel;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
