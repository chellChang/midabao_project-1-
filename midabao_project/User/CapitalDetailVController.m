
//
//  CapitalDetailVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "CapitalDetailVController.h"
#import "CapitalTVCell.h"
#import "StateTableView.h"
#import "FiltrateAlertView.h"
#import "ITDatePickerController.h"
#import "BillDetailViewController.h"
#import "capitalListViewModel.h"
#import "MJRefresh.h"
#import "UserInfoManager.h"
#import "capitalDetailModel.h"
@interface CapitalDetailVController ()<UITableViewDataSource,UITableViewDelegate,ITDatePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet StateTableView *capitalTabView;
@property (nonatomic,strong)FiltrateAlertView *filtrateView;
@property (strong,nonatomic)capitalListViewModel *capitalViewModel;
@property (strong,nonatomic)NSMutableArray *dataSourceArr;
@property (assign,nonatomic)NSInteger transType;
@property (copy , nonatomic)NSString *transDate;
@property (copy,nonatomic)NSString *transTime;
@end

@implementation CapitalDetailVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    self.transType=0;
    self.transDate=@"";
    self.transTime=@"本月";
    [self.capitalTabView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSourceArr.count>0) {
        return self.dataSourceArr.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourceArr.count>0) {
        NSDictionary *dic=self.dataSourceArr[section];
        NSArray *arr=dic.allKeys;
        NSString *currnetDate=[arr firstObject];
        NSArray *numbers=[dic valueForKey:currnetDate];
        return numbers.count;
    }
    return 0;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor=RGB(0xF2F4F6);
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(16, 9, 60, 14)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM"];
    if (self.dataSourceArr.count>0) {
        NSDictionary *dic=self.dataSourceArr[section];
        NSArray *arr=dic.allKeys;
        NSString *currnetDate=[arr firstObject];
        if ([currnetDate isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
            lab.text=@"本月";
        }else{
            lab.text=currnetDate;
        }
    }else{
        lab.text=self.transTime;
    }
    lab.textColor=RGB(0x666666);
    lab.font=[UIFont systemFontOfSize:14];
    [view addSubview:lab];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"选择月份" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitleColor:RGB(0x999999) forState:UIControlStateNormal];
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets=UIEdgeInsetsMake(0, 90, 0, 0);
    btn.frame=CGRectMake(UISCREEN_WIDTH-100-16, 0, 100, 32);
    [view addSubview:btn];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CapitalTVCell*cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CapitalTVCell class])];
    NSDictionary *dic=self.dataSourceArr[indexPath.section];
    NSArray *arr=dic.allKeys;
    NSString *currnetDate=[arr firstObject];
    NSArray *numbers=[dic valueForKey:currnetDate];
    [cell configureData:numbers[indexPath.row]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BillDetailViewController *insertVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([BillDetailViewController class])];
    NSDictionary *dic=self.dataSourceArr[indexPath.section];
    NSArray *arr=dic.allKeys;
    NSString *currnetDate=[arr firstObject];
    NSArray *numbers=[dic valueForKey:currnetDate];
    insertVc.capitalModel=numbers[indexPath.row];
    [self.navigationController pushViewController:insertVc animated:YES];
}

-(void)setCapitalTabView:(StateTableView *)capitalTabView{
    _capitalTabView=capitalTabView;
    _capitalTabView.delegate=self;
    _capitalTabView.dataSource=self;
    _capitalTabView.estimatedRowHeight=80;
    _capitalTabView.rowHeight=UITableViewAutomaticDimension;
    _capitalTabView.tableFooterView=[[UIView alloc]init];
    _capitalTabView.allowsMultipleSelection=YES;
    [_capitalTabView registerNib:[UINib nibWithNibName:NSStringFromClass([CapitalTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CapitalTVCell class])];
    @weakify(self)
    _capitalTabView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskAll];
        [self.capitalViewModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"transType":@(self.transType),@"transDate":self.transDate} success:^(NSURLSessionTask *task, id result) {
            [BaseIndicatorView hide];
            self.capitalTabView.type = 0 == self.capitalViewModel.allModels.count ? kTableStateNoInfo : kTableStateNormal;
            [self.capitalTabView.mj_header endRefreshing];
            [self dealSourceData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.capitalTabView.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.capitalTabView.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [BaseIndicatorView hide];
            self.capitalTabView.type = 0 == self.capitalViewModel.allModels.count ? kTableStateNetworkError : kTableStateNormal;
            [self.capitalTabView.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _capitalTabView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskAll];
        [self.capitalViewModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"transType":@(self.transType),@"transDate":self.transDate} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.capitalTabView.mj_footer endRefreshing];
            [self dealSourceData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.capitalTabView.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    [_capitalTabView setClickCallBack:^{
        @strongify(self)
        [self.capitalTabView.mj_header beginRefreshing];
    }];
}
-(void)dealSourceData{
    NSString *currentData=@"";
    [self.dataSourceArr removeAllObjects];
    NSMutableDictionary *mutdic=nil;
    NSMutableArray *mutArr=nil;
    if (self.capitalViewModel.allModels.count>0) {
        for (capitalDetailModel *model in self.capitalViewModel.allModels) {
            if (![model.created isEqualToString:currentData]) {//不相等的时候
                currentData=model.created;
                mutArr =[NSMutableArray arrayWithCapacity:0];
                mutdic=[NSMutableDictionary dictionaryWithCapacity:0];
                [mutArr addObject:model];
                [mutdic setValue:mutArr forKey:currentData];
                [self.dataSourceArr addObject:mutdic];
            }else{//相等的时候,添加数据
                [mutArr addObject:model];
                [mutdic setValue:mutArr forKey:currentData];
            }
        }
    }
   
    [self.capitalTabView reloadData];
}
-(FiltrateAlertView *)filtrateView{
    if (!_filtrateView) {
        _filtrateView=[[FiltrateAlertView alloc]initFiltrateViewWithframe:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
        @weakify(self)
        _filtrateView.selectBlock = ^(UIButton *btn) {
            NSLog(@"btntag(%ld)",btn.tag);
            @strongify(self)
            self.transType=btn.tag-500;
            [self.capitalTabView.mj_header beginRefreshing];
            
        };
        
    }
    return _filtrateView;
}
-(capitalListViewModel *)capitalViewModel{
    if (!_capitalViewModel) {
        _capitalViewModel=[[capitalListViewModel alloc]init];
    }
    return _capitalViewModel;
}
#pragma mark --点击筛选
- (IBAction)filtrateClick:(id)sender {
     UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self.filtrateView showInWindow:window];
}
#pragma mark --点击选择月份
-(void)chooseMonth{
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 200;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = YES;// Whether to show "today", default is yes
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy.mm";
//    datePickerController.minimumDate=[dateFormatter dateFromString:@"2017.07"];
//    datePickerController.maximumDate=[dateFormatter dateFromString:@"2017.10"];
    
    [self presentViewController:datePickerController animated:YES completion:nil];
}
#pragma mark - ITDatePickerControllerDelegate
//点击完成
- (void)datePickerController:(ITDatePickerController *)datePickerController didSelectedDate:(NSDate *)date dateString:(NSString *)dateString {
    if ([dateString isEqualToString:@"至今"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMM"];
        
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        self.transDate =dateTime;
        self.transTime=@"本月";
        [self.capitalTabView.mj_header beginRefreshing];
    }else{
        NSArray *arr=[dateString componentsSeparatedByString:@"."];
        if (arr.count>1) {
            self.transTime=dateString;
            self.transDate=[NSString stringWithFormat:@"%@%@",arr[0],arr[1]];
            [self.capitalTabView.mj_header beginRefreshing];
        }
    }
}
#pragma mark --点击全部
-(void)datePickerControllerClcikLeftTabItem{
   self.transDate=@"";
    [self.capitalTabView.mj_header beginRefreshing];
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
