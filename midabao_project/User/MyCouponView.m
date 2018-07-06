//
//  MyCouponView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyCouponView.h"
#import "StateTableView.h"
#import "CouponTVCell.h"
#import "NSString+ExtendMethod.h"
#import "MJRefresh.h"
#import "couponViewModel.h"
#import "UserInfoManager.h"
@interface MyCouponView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *contentTabview;
@property (strong,nonatomic)couponViewModel *mycouponVModel;
@property (assign,nonatomic)NSInteger state;
@end
@implementation MyCouponView
+(instancetype)customViewWithState:(NSInteger)state{
    MyCouponView *view=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    if ([view isMemberOfClass:[self class]]) {
        view.state=state;
        view.needRefreshList = YES;
        return view;
    }
    return nil;
}
- (void)beginRefresh {
    if (self.needRefreshList) {
        [self.contentTabview.mj_header beginRefreshing];
    }
}
- (void)stopRefreshing {
    [self.mycouponVModel.operation cancelFetchOperation];
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mycouponVModel.allModels.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.mycouponVModel.allModels.count>0)
        return 40;
    return self.contentTabview.bounds.size.height-100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.mycouponVModel.allModels.count>0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(16, 16, UISCREEN_WIDTH-32, 14)];
        NSString *titleStr=@"";
        switch (self.state) {
            case 1:
                titleStr=@"个加息券可用";
                break;
            case 2:
                titleStr=@"个红包可用";
                break;
            case 3:
                titleStr=@"个体验金可用";
                break;
            default:
                break;
        }
        lab.textColor=RGB(0x333333);
        NSString *title=[NSString stringWithFormat:@"有%ld%@",self.mycouponVModel.allModels.count,titleStr];
        lab.attributedText=[title changeAttributeStringWithAttribute:@{NSForegroundColorAttributeName:RGB(0xFF2C2C)} Range:NSMakeRange(1, 1)];
        lab.font=[UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    switch (self.state) {
        case 1:
            [btn setTitle:@"查看已使用和已失效的加息券" forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:@"查看已使用和已失效的红包" forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitle:@"查看已使用和已失效的体验金" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitleColor:RGB(0x3379EA) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(16, 40, UISCREEN_WIDTH-16, 20);
    return btn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mycouponVModel.allModels.count>0) {
        CouponTVCell*cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CouponTVCell class])];
        @weakify(self)
        cell.usedcoupon = ^(NSString *couponID) {
            @strongify(self)
            NSLog(@"--(%@)",couponID);
            if ([self.delegate respondsToSelector:@selector(usdCoupoonWithcouponId:andCurrentState:)]) {
                [self.delegate usdCoupoonWithcouponId:couponID andCurrentState:self.state];
            }
        };
        [cell configuremyallcouponwithdata:self.mycouponVModel.allModels[indexPath.row]];
        return cell;
    }
    return nil;
}
-(void)btnClick{
    [self.delegate seeUsedCouponViewWithState:self.state];
}
-(void)setContentTabview:(StateTableView *)contentTabview{
    _contentTabview=contentTabview;
    _contentTabview.delegate=self;
    _contentTabview.dataSource=self;
    _contentTabview.estimatedRowHeight=130;
    _contentTabview.rowHeight=UITableViewAutomaticDimension;
    _contentTabview.sectionFooterHeight = 0;
    _contentTabview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_contentTabview registerNib:[UINib nibWithNibName:NSStringFromClass([CouponTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CouponTVCell class])];
    @weakify(self)
    _contentTabview.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
        [self.mycouponVModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"couponType":@(self.state),@"couponStatus":@1} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            self.needRefreshList = NO;
            [self.contentTabview.mj_header endRefreshing];
            self.contentTabview.type = 0 == self.mycouponVModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.contentTabview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.contentTabview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.contentTabview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.contentTabview.mj_header endRefreshing];
            self.contentTabview.type = 0 == self.mycouponVModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _contentTabview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self maskType:kIndicatorNoMask];
        [self.mycouponVModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"couponType":@(self.state),@"couponStatus":@1} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            [self.contentTabview.mj_footer endRefreshing];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.contentTabview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_contentTabview setClickCallBack:^{
        [_contentTabview.mj_header beginRefreshing];
    }];
}
-(couponViewModel *)mycouponVModel{
    if (!_mycouponVModel) {
        _mycouponVModel=[[couponViewModel alloc]init];
    }
    return _mycouponVModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
