//
//  ProjectCalendarVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectCalendarVController.h"
#import "StateTableView.h"
#import "ProjectDateTopTVCell.h"
#import "ProjectDateMiddleTVCell.h"
#import "ProjectDateBottomTVCell.h"
#import "projectCalendarModel.h"
#import "UserInfoManager.h"
@interface ProjectCalendarVController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet StateTableView *dateTabview;
@property (strong,nonatomic)NetWorkOperation *operation;
@property (strong,nonatomic)NSMutableArray *dataSourceArr;
@property (copy , nonatomic)NSString *qixiTimestr;
@property (copy , nonatomic)NSString *buyTimestr;
@property (assign,nonatomic)BOOL isRefirshUI;
@end

@implementation ProjectCalendarVController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    self.isRefirshUI=NO;
    [self RequestData];
    // Do any additional setup after loading the view.
}
-(void)RequestData{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"repaymentQuery" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"invId":self.investId,@"projectId":self.projectId} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        self.buyTimestr=[CommonTools dealDate:[CommonTools convertToStringWithObject:result[RESULT_DATA][@"invTime"]] andpreserve:1 andType:1];
        self.qixiTimestr=[CommonTools dealDate:[CommonTools convertToStringWithObject:result[RESULT_DATA][@"interestTime"]] andpreserve:1 andType:1];
        [result[RESULT_DATA][@"userRepayment"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            projectCalendarModel *model=[projectCalendarModel yy_modelWithJSON:obj];
            [self.dataSourceArr addObject:model];
        }];
        self.isRefirshUI=YES;
        self.dateTabview.type=kTableStateNormal;
        [self.dateTabview reloadData];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        self.isRefirshUI=NO;
        self.dateTabview.type=kTableStateNetworkError;
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isRefirshUI) {
        return self.dataSourceArr.count+2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 64;
    }else if (indexPath.row==(self.dataSourceArr.count+2-1)){
        return 95;
    }
    return 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0||indexPath.row==1) {
        ProjectDateTopTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDateTopTVCell class])];
        if (indexPath.row==0) {
            [cell createUiwithState:0 andTime:self.buyTimestr];
        }else if (indexPath.row==1){
            [cell createUiwithState:1 andTime:self.qixiTimestr];
        }
        return cell;
    }else if (indexPath.row==(self.dataSourceArr.count+2-1)){
        ProjectDateBottomTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDateBottomTVCell class])];
        [cell configureWithData:self.dataSourceArr[indexPath.row-2]];
        return cell;
    }
    ProjectDateMiddleTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectDateMiddleTVCell class])];
    [cell configureWithData:self.dataSourceArr[indexPath.row-2]];
    return cell;
}
-(void)setDateTabview:(StateTableView *)dateTabview{
    _dateTabview=dateTabview;
    _dateTabview.dataSource=self;
    _dateTabview.delegate=self;
    [_dateTabview registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDateTopTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDateTopTVCell class])];
    [_dateTabview registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDateMiddleTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDateMiddleTVCell class])];
    [_dateTabview registerNib:[UINib nibWithNibName:NSStringFromClass([ProjectDateBottomTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProjectDateBottomTVCell class])];
    @weakify(self)
    [_dateTabview setClickCallBack:^{
        @strongify(self)
        [self RequestData];
    }];
}
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
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
