//
//  FindingVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FindingVController.h"
#import "FindingHeaderView.h"
#import "StateTableView.h"
#import "ActiveTVCell.h"
#import "FindingHeaderView.h"
#import "MessageVController.h"
#import "FindListViewModel.h"
#import "MJRefresh.h"
#import "ServiceCenterVC.h"
#import "UserInfoManager.h"
#import "LoginNavigationVController.h"
#import "SignVController.h"
#import "WebVC.h"
#import "InvitefriendVController.h"
#import "UInilViewCell.h"
@interface FindingVController ()<UITableViewDataSource,UITableViewDelegate,FindingHeaderViewDelegate,SGAdvertScrollViewDelegate>
@property (weak, nonatomic) IBOutlet StateTableView *findTableview;
@property (strong,nonatomic)NSMutableArray *contentArr;
@property (nonatomic,strong)FindingHeaderView *headerView;
@property (nonatomic,strong)FindListViewModel *findViewModel;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation FindingVController
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.findTableview.tableHeaderView=self.headerView;
//    self.findTableview.sectionHeaderHeight=0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView.labSlider addTimer];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [self.findViewModel.operation cancelFetchOperation];
    [self.headerView.labSlider removeTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.findTableview.mj_header beginRefreshing];
    dispatch_async(dispatch_queue_create(0, 0), ^{
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"articlefind" params:@{@"findType":@"1",@"pageIndex":@1,@"pageSize":@(20)} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            NSLog(@"%@",result);
            if (self.contentArr.count>0) {
                [self.contentArr removeAllObjects];
            }
            [result[RESULT_DATA][@"articleList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                findListModel *model=[findListModel yy_modelWithJSON:obj];
                [self.contentArr addObject:model];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                NSMutableArray *topArr=[NSMutableArray arrayWithCapacity:0];
                NSMutableArray *bottomArr=[NSMutableArray arrayWithCapacity:0];
                [topArr removeAllObjects];
                [bottomArr removeAllObjects];
                for (int i=0; i<self.contentArr.count; i++) {
                    findListModel *model=self.contentArr[i];
                    if (i%2==0) {//偶数
                        [bottomArr addObject:model.title];
                    }else{//奇数
                        [topArr addObject:model.title];
                    }
                }
                self.headerView.labSlider.topTitles=topArr;
                self.headerView.labSlider.bottomTitles=bottomArr;
            });
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [SpringAlertView showMessage:errorDescription];
        }];
        
    });
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.findViewModel.allModels.count>0) {
        return 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0==self.findViewModel.allModels.count?1:self.findViewModel.allModels.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.findViewModel.allModels.count>0) {
        return UITableViewAutomaticDimension;
    }
    return 225;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.findViewModel.allModels.count>0) {
        ActiveTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActiveTVCell class])];
        [cell configureUi:self.findViewModel.allModels[indexPath.row]];
        return cell;
    }
    UInilViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UInilViewCell class])];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.findViewModel.allModels.count>0) {
        findListModel *model=self.findViewModel.allModels[indexPath.row];
        WebVC *web=[[WebVC alloc] initWithWebPath:model.url];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, UISCREEN_WIDTH, 48)];
    blackView.backgroundColor=[UIColor whiteColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(16, 16, 100, 16)];
    lab.text=@"热门活动";
    lab.font=[UIFont boldSystemFontOfSize:16];
    lab.textColor=RGB(0x333333);
    UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
    lineImg.image=[UIImage imageNamed:@"lineX_e5"];
    [blackView addSubview:lineImg];
    [blackView addSubview:lab];
    return blackView;
}
#pragma mark --FindingHeaderViewDelegate
-(void)clickfindHeadview:(findType)findtype{
    if (findtype==seeMsg) {
        if (self.contentArr.count>0) {
            MessageVController *msgVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([MessageVController class])];
            [self.navigationController pushViewController:msgVc animated:YES];
        }else{
            [SpringAlertView showMessage:@"暂无头条内容"];
        }
        
    }else if (findtype==kfhostline){
        ServiceCenterVC *serviceVC=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ServiceCenterVC class])];
        [self.navigationController pushViewController:serviceVC animated:YES];
    }else if (findtype==sigineverday){
        if (![UserInfoManager shareUserManager].logined) {
            [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
            return;
        }
        SignVController *signVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SignVController class])];
        [self.navigationController pushViewController:signVc animated:YES];
    }else if(findtype==complanInfo){
        WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/companyIntroduction.html"];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }else if (findtype==invitePeople){
        if (![UserInfoManager shareUserManager].logined) {
            [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        }else{
            InvitefriendVController *inviteVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([InvitefriendVController class])];
            [self.navigationController pushViewController:inviteVc animated:YES];
        }
    }else if (findtype==safetyguarantee){
        WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/safe.html"];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }else if (findtype==aboutme){
        WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/companyTab.html"];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }else if (findtype==newguider){
        WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/guide.html"];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }else if (findtype==helpcenter){
        WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/help.html"];
        web.needPopAnimation=YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}



-(void)setFindTableview:(StateTableView *)findTableview{
    _findTableview=findTableview;
    _findTableview.delegate=self;
    _findTableview.dataSource=self;
    _findTableview.estimatedRowHeight=194;
//    _findTableview.tableHeaderView=self.headerView;
    _findTableview.rowHeight=UITableViewAutomaticDimension;
    _findTableview.sectionFooterHeight = 0;
    _findTableview.tableFooterView=[[UIView alloc]init];
    _findTableview.allowsMultipleSelection = YES;
    [_findTableview registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ActiveTVCell class])];
     [_findTableview registerNib:[UINib nibWithNibName:NSStringFromClass([UInilViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UInilViewCell class])];
    @weakify(self)
    MJRefreshStateHeader *heade=[[MJRefreshStateHeader alloc]init];
    heade.stateLabel.font=[UIFont systemFontOfSize:13];
//    _findTableview.mj_header.
    _findTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.findViewModel fetchFirstPageWithParams:@{@"findType":@"2"} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [self.findTableview.mj_header endRefreshing];
            [self.findTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.findTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.findTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [self.findTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    
    _findTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.findViewModel fetchNextPageWithParams:@{@"findType":@"2"} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [self.findTableview.mj_footer endRefreshing];
            [self.findTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [self.findTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
}
-(FindListViewModel *)findViewModel{
    if (!_findViewModel) {
        _findViewModel=[[FindListViewModel alloc]init];
    }
    return _findViewModel;
}
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _contentArr;
}
-(FindingHeaderView *)headerView{
    if (!_headerView) {
        _headerView=[[FindingHeaderView alloc]initFindingHeaderViewWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 258)];
        _headerView.delegate=self;
        _headerView.labSlider.advertScrollViewStyle=SGAdvertScrollViewStyleMore;
//        _headerView.labSlider.topTitles = @[@"聚惠女王节，香米更低价满150减10", @"HTC新品首发，预约送大礼包", @"“挑食”进口生鲜，满199减20"];
//        _headerView.labSlider.topSignImages=@[@"bluePoint", @"bluePoint", @"bluePoint"];
//        _headerView.labSlider.bottomSignImages = @[@"bluePoint", @"bluePoint", @"bluePoint"];
        _headerView.labSlider.dotimgname=@"dotIcon";
//        _headerView.labSlider.bottomTitles = @[@"满150减10+满79减5", @"12期免息＋免费试用"];
        _headerView.labSlider.scrollTimeInterval = 5;
        _headerView.labSlider.delegate = self;
        _headerView.labSlider.titleFont = [UIFont systemFontOfSize:14];
    }
    return _headerView;
}
//文字轮播的代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"---%ld",index);
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
