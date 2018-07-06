//
//  InvestmentView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvestmentView.h"
#import "StateTableView.h"
#import "MJRefresh.h"
#import "InvestmentViewModel.h"
#import "RankingListTVCell.h"
#import "InvestmentListTVCell.h"
@interface InvestmentView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)StateTableView *tableview;
@property (strong,nonatomic)InvestmentViewModel *viewModel;
@property (nonatomic,strong)projectDetailModel *projectModel;
@end
@implementation InvestmentView
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
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([RankingListTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RankingListTVCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([InvestmentListTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InvestmentListTVCell class])];
    @weakify(self)
    self.tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.projectModel.productId!=nil&&![self.projectModel.productId isKindOfClass:[NSNull class]]) {
            [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
            [self.viewModel fetchNextPageWithParams:@{@"projectId":self.projectModel.projectId} success:^(NSURLSessionTask *task, id result) {
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
        if (self.projectModel.productId!=nil) {
            [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
            [self.viewModel fetchFirstPageWithParams:@{@"projectId":self.projectModel.projectId} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                [BaseIndicatorView hide];
                if (self.projectModel.investmentRankingList.count==0&&self.viewModel.allModels.count==0) {
                    self.tableview.type=kTableStateNoInfo;
                }else{
                    self.tableview.type = kTableStateNormal;
                }
                [self.tableview reloadData];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                if (self.projectModel.investmentRankingList.count==0&&self.viewModel.allModels.count==0) {
                    self.tableview.type=kTableStateNetworkError;
                }else{
                    self.tableview.type = kTableStateNormal;
                }
                
                [BaseIndicatorView hide];
                [SpringAlertView showMessage:errorDescription];
            }];
        }
    }];
    [self addSubview:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.projectModel.investmentRankingList.count>0&&self.viewModel.allModels.count>0) {
        return 2;
    }else if (self.projectModel.investmentRankingList.count>0||self.viewModel.allModels.count>0){
        return 1;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.projectModel.investmentRankingList.count>0&&self.viewModel.allModels.count>0) {
        if (section==0) {
            return 1;
        }
        return self.viewModel.allModels.count;
    }else if (self.projectModel.investmentRankingList.count>0){
        return 1;
    }else if(self.viewModel.allModels.count>0){
        return self.viewModel.allModels.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.projectModel.investmentRankingList.count>0&&self.viewModel.allModels.count>0) {
        if (indexPath.section==1) {
            if (self.viewModel.allModels.count-1==indexPath.row) {
                return 50;
            }else{
                return 35;
            }
        }
    }else if (self.viewModel.allModels.count>0){
        if (indexPath.section==1) {
            if (self.viewModel.allModels.count-1==indexPath.row) {
                return 50;
            }else{
                return 35;
            }
        }
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
    if (self.projectModel.investmentRankingList.count>0&&self.viewModel.allModels.count>0) {
        if (indexPath.section==0) {
            RankingListTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingListTVCell class])];
            [cell configureui:self.projectModel.investmentRankingList];
            return cell;
        }else{
            InvestmentListTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InvestmentListTVCell class])];
            [cell configureUi:self.viewModel.allModels[indexPath.row]];
            return cell;
        }
    }else if (self.projectModel.investmentRankingList.count>0){
        RankingListTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingListTVCell class])];
        [cell configureui:self.projectModel.investmentRankingList];
        return cell;
    }else{
        InvestmentListTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InvestmentListTVCell class])];
        [cell configureUi:self.viewModel.allModels[indexPath.row]];
        
        return cell;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentOffSetY=scrollView.contentOffset.y;
    CGFloat beforeHeight=30*(-1);
    NSLog(@"------(%f)",contentOffSetY);
    if (contentOffSetY<beforeHeight) {
        NSLog(@"上一页");
        [self.delegate investmentPullupView];
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
-(void)RefirshUIModel:(projectDetailModel *)model{
    if (model.productId!=nil&&![model.productId isKindOfClass:[NSNull class]]) {
        if (self.projectModel.productId==nil||[self.projectModel.productId isKindOfClass:[NSNull class]]) {
            self.projectModel=model;
            [BaseIndicatorView showInView:self maskType:kIndicatorMaskAll];
            @weakify(self)
            [self.viewModel fetchFirstPageWithParams:@{@"projectId":model.projectId} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                [BaseIndicatorView hide];
                if (self.projectModel.investmentRankingList.count==0&&self.viewModel.allModels.count==0) {
                    self.tableview.type=kTableStateNoInfo;
                }else{
                    self.tableview.type = kTableStateNormal;
                }
                [self.tableview reloadData];
                if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                    self.tableview.mj_footer.state=MJRefreshStateIdle;
                }else{
                    self.tableview.mj_footer.state=MJRefreshStateNoMoreData;
                }
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                if (self.projectModel.investmentRankingList.count==0&&self.viewModel.allModels.count==0) {
                    self.tableview.type=kTableStateNetworkError;
                }else{
                    self.tableview.type = kTableStateNormal;
                }
                [BaseIndicatorView hide];
                [SpringAlertView showMessage:errorDescription];
            }];
        }
        
    }
    
}
-(InvestmentViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel=[[InvestmentViewModel alloc]init];
    }
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
