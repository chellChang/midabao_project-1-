



//
//  SignVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "SignVController.h"
#import "SignPopView.h"
#import "SignListVController.h"
#import "SiginModel.h"
#import "UserInfoManager.h"
@interface SignVController ()
@property (weak, nonatomic) IBOutlet UIView *TopSuperView;
@property (weak, nonatomic) IBOutlet UILabel *myIntegral;
@property (weak, nonatomic) IBOutlet UILabel *todayIntegral;
@property (weak, nonatomic) IBOutlet UILabel *continuousDays;
@property (weak, nonatomic) IBOutlet UILabel *sevenDayIntegral;
@property (nonatomic,strong)SignPopView *popView;
@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation SignVController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"siginIntegral" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
         [BaseIndicatorView hide];
        self.popView.signNumber.text=[NSString stringWithFormat:@"积分+%@",result[RESULT_DATA][@"integ"]];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [self.popView showInWindow:window];
        [self RequestData];
       
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [self RequestData];
    }];
    
    
    
}
-(void)RequestData{
    //获取签到信息
    self.operation=[NetWorkOperation SendRequestWithMethods:@"getIntegral" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
        SiginModel *model=[SiginModel yy_modelWithJSON:result[RESULT_DATA]];
        [self UpdateSiginData:model];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(void)UpdateSiginData:(SiginModel *)model{
    self.myIntegral.text=[NSString stringWithFormat:@"%ld",model.integSum];
    self.todayIntegral.text=[NSString stringWithFormat:@"+%ld",model.thisInteg];
    self.continuousDays.text=[NSString stringWithFormat:@"你已连续签到%ld天",model.integDay];
    self.sevenDayIntegral.text=[NSString stringWithFormat:@"一周签到七天可额外获得%ld积分",model.extraInteg];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    for (int i=0; i<model.ipList.count; i++) {
        NSDictionary *dic=model.ipList[i];
        UIView *itemView=[self.TopSuperView viewWithTag:111+i];
        UILabel *monthLab=[itemView viewWithTag:211+i];
        UILabel *dataLab=[itemView viewWithTag:311+i];
        UIImageView *TagImg=[itemView viewWithTag:411+i];
        NSString *days=[CommonTools convertToStringWithObject:dic[@"day"]];
        if ([days isEqualToString:dateTime]) {
            //当天
            monthLab.text=@"今";
            monthLab.textColor=RGB(0x3379EA);
            dataLab.textColor=RGB(0x3379EA);
            itemView.backgroundColor=[UIColor whiteColor];
        }else{
            itemView.backgroundColor=RGB(0xF2F4F6);
            dataLab.textColor=RGB(0x666666);
        }
        if ([dic[@"bool"]boolValue]) {
            TagImg.hidden=NO;
        }else{
            TagImg.hidden=YES;
        }
        dataLab.text=days;
        
        
        
    }
}
#pragma mark --查看积分记录
- (IBAction)signlistclick:(id)sender {
    SignListVController *ListVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SignListVController class])];
    [self.navigationController pushViewController:ListVc animated:YES];
}
-(SignPopView *)popView{
    if (!_popView) {
        _popView=[SignPopView signInSuccessPromptView];
    }
    return _popView;
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
