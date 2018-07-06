
//
//  DiscountCouponVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "DiscountCouponVC.h"
#import "StateTableView.h"
#import "CouponTVCell.h"
#import "MJRefresh.h"
#import "couponViewModel.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
@interface DiscountCouponVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *CouponTableview;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *canusedNumber;
@property (strong,nonatomic)couponViewModel *couponViewmodel;
@end

@implementation DiscountCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.CouponTableview.mj_header beginRefreshing];
    NSString *couponnumstr=[NSString stringWithFormat:@"有%ld张优惠券可用",self.cancouponnum];
    self.canusedNumber.attributedText=[couponnumstr changeAttributeStringWithAttribute:@{NSForegroundColorAttributeName:RGB(0xFF2C2C)} Range:NSMakeRange(1, couponnumstr.length-7)];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.couponViewmodel.operation cancelFetchOperation];
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponViewmodel.allModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponTVCell*cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CouponTVCell class])];
    couponrModel *couponModel=self.couponViewmodel.allModels[indexPath.row];
    if (self.currentMoney!=-1) {
        if (couponModel.couponType==2) {//满减券
            if (couponModel.investPriceUp>self.currentMoney) {
                couponModel.isAva=0;
            }
        }
    }
    if (![self.couponIds isEqualToString:@""]) {//说明选择了优惠券
        if ([couponModel.couponrId isEqualToString:self.couponIds]) {
            couponModel.isselected=YES;
        }
    }
    @weakify(cell)
    [RACObserve(couponModel, isselected) subscribeNext:^(NSString *x){
        @strongify(cell)
        if ([x boolValue]==YES) {
            cell.chooseImg.image=[UIImage imageNamed:@"redpacket"];
        }else{
            cell.chooseImg.image=[UIImage imageNamed:@"redpacketUn"];
        }
    }];
    [cell configureUIwithD:couponModel];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    couponrModel *model = self.couponViewmodel.allModels[indexPath.row];
    if (model.useStatus==1&&model.isAva==1) {//可用
        for (NSInteger i = 0; i<[self.couponViewmodel.allModels count]; i++) {
            couponrModel *itemViewModel = self.couponViewmodel.allModels[i];
            if (i!=indexPath.row) {
                itemViewModel.isselected = NO;
            }else if (i == indexPath.row){
                itemViewModel.isselected = YES;
            }
        }
        [self.CouponTableview reloadData];
        NSString *showcouponstr=@"";
        if (model.couponType==1) {//加息券
            showcouponstr=[NSString stringWithFormat:@" %.1f%%加息券 .",model.couponPrice];
            
        }else if (model.couponType==2){//满减券
            showcouponstr=[NSString stringWithFormat:@" %.0f元红包 .",model.couponPrice];
        }
        !self.usedCoupon? :self.usedCoupon(showcouponstr,model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)notusedcouponClick:(id)sender {
    !self.usedCoupon? :self.usedCoupon(@"",nil);
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setCouponTableview:(StateTableView *)CouponTableview{
    _CouponTableview=CouponTableview;
    _CouponTableview.delegate=self;
    _CouponTableview.dataSource=self;
    _CouponTableview.estimatedRowHeight=130;
    _CouponTableview.rowHeight=UITableViewAutomaticDimension;
    _CouponTableview.sectionFooterHeight = 0;
     _CouponTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_CouponTableview registerNib:[UINib nibWithNibName:NSStringFromClass([CouponTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CouponTVCell class])];
    @weakify(self)
    _CouponTableview.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.couponViewmodel fetchFirstPageWithParams:@{@"projectId":self.projectId,@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            [self.CouponTableview.mj_header endRefreshing];
            self.CouponTableview.type = 0 == self.couponViewmodel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.CouponTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.CouponTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.CouponTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.CouponTableview.mj_header endRefreshing];
            self.CouponTableview.type = 0 == self.couponViewmodel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _CouponTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       @strongify(self)
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.couponViewmodel fetchNextPageWithParams:@{@"projectId":self.projectId,@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            [self.CouponTableview.mj_footer endRefreshing];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            [self.CouponTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_CouponTableview setClickCallBack:^{
        [_CouponTableview.mj_header beginRefreshing];
    }];
    
}
-(couponViewModel *)couponViewmodel{
    if (!_couponViewmodel) {
        _couponViewmodel =[[couponViewModel alloc]init];
    }
    return _couponViewmodel;
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
