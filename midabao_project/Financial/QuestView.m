//
//  QuestView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "QuestView.h"
#import "StateTableView.h"
#import "FKQuestionTVCell.h"
#import "MJRefresh.h"
#import "questlistViewModel.h"

@interface QuestView()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)StateTableView *tableview;
@property (strong,nonatomic)questlistViewModel *questViewModel;
@end
@implementation QuestView
-(instancetype)initCustomFrome:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.tableview=[[StateTableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableview.estimatedRowHeight=74;
    self.tableview.rowHeight=UITableViewAutomaticDimension;
    self.tableview.sectionFooterHeight = 0.1;
    self.tableview.sectionHeaderHeight=0.1;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FKQuestionTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FKQuestionTVCell class])];
    @weakify(self)
    self.tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.projectId!=nil&&![self.projectId isKindOfClass:[NSNull class]]) {
            [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
            [self.questViewModel fetchNextPageWithParams:@{@"productId":self.projectId} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                [BaseIndicatorView hide];
                [self.tableview.mj_footer endRefreshing];
                [self.tableview reloadData];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                @strongify(self)
                [BaseIndicatorView hide];
                [self.tableview.mj_footer endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }
        
    }];
    [self.tableview setClickCallBack:^{
        @strongify(self)
        if (self.projectId!=nil&&![self.projectId isKindOfClass:[NSNull class]]) {
            [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
            @weakify(self)
            [self.questViewModel fetchFirstPageWithParams:@{@"productId":self.projectId} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                [BaseIndicatorView hide];
                self.tableview.type = 0 == self.questViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
                [self.tableview reloadData];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                self.tableview.type = 0 == self.questViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
                [BaseIndicatorView hide];
                [SpringAlertView showMessage:errorDescription];
            }];
        }
    }];
    [self addSubview:self.tableview];
}
-(void)RefirshUI:(NSString *)projId{
    if (self.projectId==nil||[self.projectId isKindOfClass:[NSNull class]]) {
        self.projectId=projId;
        [BaseIndicatorView showInView:self maskType:kIndicatorMaskAll];
        @weakify(self)
        [self.questViewModel fetchFirstPageWithParams:@{@"productId":projId} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            self.tableview.type = 0 == self.questViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.tableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.tableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.tableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            self.tableview.type = 0 == self.questViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [BaseIndicatorView hide];
            [SpringAlertView showMessage:errorDescription];
        }];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questViewModel.allModels.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FKQuestionTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKQuestionTVCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.questViewModel.allModels.count-1==indexPath.row) {
        cell.bottomLineX.hidden=YES;
    }else{
        cell.bottomLineX.hidden=NO;
    }
    [cell configurUI:self.questViewModel.allModels[indexPath.row]];
    return cell;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentOffSetY=scrollView.contentOffset.y;
    CGFloat beforeHeight=30*(-1);
    NSLog(@"------(%f)",contentOffSetY);
    if (contentOffSetY<beforeHeight) {
        NSLog(@"上一页");
        [self.delegate questpullUpView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==self.tableview) {
        if (self.tableview.contentOffset.y<0) {
            //            [self.text3.tableview setContentInset:UIEdgeInsetsMake(self.text3.tableview.contentOffset.y, 0, 0, 0)];
            [self.bankScroll setContentOffset:self.tableview.contentOffset];
        }else if (self.tableview.contentOffset.y>0){
            //            self.text3.tableview.bounces=YES;
        }
    }
    
}
-(questlistViewModel *)questViewModel{
    if (!_questViewModel) {
        _questViewModel=[[questlistViewModel alloc]init];
    }
    return _questViewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
