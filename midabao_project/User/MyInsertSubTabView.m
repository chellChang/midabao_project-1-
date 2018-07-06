
//
//  MyInsertSubTabView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyInsertSubTabView.h"
#import "InsertTVCell.h"
#import "MJRefresh.h"
#import "UserInfoManager.h"
#import "UInilViewCell.h"
#import "myinvestlistModel.h"
@interface MyInsertSubTabView()<UITableViewDataSource, UITableViewDelegate>
@property (assign,nonatomic)NSInteger currentState;
@end
@implementation MyInsertSubTabView
+(MyInsertSubTabView *)contentTableviewWithState:(NSInteger)state{
    MyInsertSubTabView *contentTab=[[MyInsertSubTabView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if ([contentTab isMemberOfClass:[self class]]) {
        [contentTab registerNib:[UINib nibWithNibName:NSStringFromClass([InsertTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InsertTVCell class])];
        [contentTab registerNib:[UINib nibWithNibName:NSStringFromClass([UInilViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UInilViewCell class])];
        contentTab.delegate=contentTab;
        contentTab.needRefirsh=YES;
        contentTab.dataSource=contentTab;
        contentTab.separatorStyle=UITableViewCellSeparatorStyleNone;
        contentTab.estimatedRowHeight=146;
        contentTab.rowHeight=UITableViewAutomaticDimension;
        contentTab.sectionFooterHeight = 0;
        contentTab.allowsMultipleSelection = YES;
        contentTab.currentState=state;
        @weakify(contentTab)
        contentTab.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(contentTab)
            [BaseIndicatorView showInView:contentTab maskType:kIndicatorNoMask];
            [contentTab.investViewModel fetchNextPageWithParams:@{@"projectStatus":[NSString stringWithFormat:@"%ld",state],@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
                [BaseIndicatorView hide];
                [contentTab.mj_footer endRefreshing];
                [contentTab reloadData];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                [BaseIndicatorView hide];
                [contentTab.mj_footer endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }];

        return contentTab;
    }
    
    return nil;
}
-(void)firstRefirshUIWithView{
    if (self.needRefirsh) {
        [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
        [self.investViewModel fetchFirstPageWithParams:@{@"projectStatus":[NSString stringWithFormat:@"%ld",self.currentState],@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            self.needRefirsh=NO;
            [self.investViewModel configureDateWithResule:result[RESULT_DATA][@"userInvestmentList"]];
            [self reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.mj_footer.state=MJRefreshStateNoMoreData;
            }
            [BaseIndicatorView hide];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [SpringAlertView showMessage:errorDescription];
        }];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.investViewModel.allModels.count>0?self.investViewModel.allModels.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.investViewModel.allModels.count>0) {
        return 146;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.investViewModel.allModels.count>0) {
        InsertTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InsertTVCell class])];
        
        [cell configureUIWithData:self.investViewModel.allModels[indexPath.section]];
        return cell;
    }
    UInilViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UInilViewCell class])];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.investViewModel.allModels.count>0) {
        if ([self.Mydelelgate respondsToSelector:@selector(didSelectRowWithID:)]) {
            myinvestlistModel *model=self.investViewModel.allModels[indexPath.section];
            [self.Mydelelgate didSelectRowWithID:model.projectId];
        }
    }
}
-(investListViewModel *)investViewModel{
    if (!_investViewModel) {
        _investViewModel=[[investListViewModel alloc]init];
    }
    return _investViewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
