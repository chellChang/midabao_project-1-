
//
//  InsertDetailVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InsertDetailVController.h"
#import "ProjectCalendarVController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UserInfoManager.h"
#import "UILabel+Format.h"
#import "ProjectDetailVC.h"
@interface InsertDetailVController ()
@property (weak, nonatomic) IBOutlet UIButton *calendelBtn;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *huankuanStpe;
@property (weak, nonatomic) IBOutlet UILabel *investTime;
@property (weak, nonatomic) IBOutlet UILabel *qixiTime;
@property (weak, nonatomic) IBOutlet UILabel *daoqiTime;
@property (weak, nonatomic) IBOutlet UILabel *investMoney;
@property (weak, nonatomic) IBOutlet UILabel *yuqiyearRate;
@property (weak, nonatomic) IBOutlet UILabel *lemtDay;
@property (weak, nonatomic) IBOutlet UILabel *huankuanType;
@property (weak, nonatomic) IBOutlet UILabel *yuqiRate;
@property (weak, nonatomic) IBOutlet UILabel *couponNumber;
@property (weak, nonatomic) IBOutlet UILabel *daishouMoney;
@property (weak, nonatomic) IBOutlet UILabel *daishoushouyiLab;
@property (weak, nonatomic) IBOutlet UILabel *yishouMoney;
@property (weak, nonatomic) IBOutlet UILabel *yishoushouyi;
@property (weak, nonatomic) IBOutlet UILabel *qixititleLab;
@property (weak, nonatomic) IBOutlet UILabel *daoqititleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightCos;
@property (weak, nonatomic) IBOutlet UIView *projectstateView;

@property (copy , nonatomic)NSString *projectId;

@property (strong,nonatomic)NetWorkOperation *operation;
@end

@implementation InsertDetailVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
    self.navigationController.navigationBar.translucent=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.bankScrollview.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent=YES;
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    self.operation=[NetWorkOperation SendRequestWithMethods:@"investmentDetailquery" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid,@"invId":self.investId} success:^(NSURLSessionTask *task, id result) {
        [BaseIndicatorView hide];
        [self refirshUIWithData:result[RESULT_DATA][@"invDetails"]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
    // Do any additional setup after loading the view.
}
-(void)refirshUIWithData:(NSDictionary *)resuledata{
    self.projectName.text=[CommonTools convertToStringWithObject:resuledata[@"proName"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[[CommonTools convertToStringWithObject:resuledata[@"invTime"]] integerValue]/1000];
    self.investTime.text=[formatter stringFromDate:date1];
    switch ([resuledata[@"projectStatus"]integerValue]) {
        case 5:
        {
            self.huankuanStpe.text=@"募集中";
            self.projectstateView.backgroundColor=RGB(0xFF7F1B);
            self.qixititleLab.text=@"募集截止时间";
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"entTime"]];
            if (qixiStr==nil||[qixiStr isEqualToString:@""]||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            self.calendelBtn.hidden=YES;
            self.topHeightCos.constant=106;
            self.daoqititleLab.hidden=YES;
            self.daoqiTime.hidden=YES;
        }
            break;
        case 6:
        {
            self.huankuanStpe.text=@"已满标";
            self.calendelBtn.hidden=NO;
            self.projectstateView.backgroundColor=RGB(0x3379EA);
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"interestTime"]];
            if (qixiStr==nil||[qixiStr isEqualToString:@""]||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            NSString *daoqiStr=[CommonTools convertToStringWithObject:resuledata[@"repTime"]];
            if (daoqiStr==nil||[daoqiStr isEqualToString:@""]||[daoqiStr isKindOfClass:[NSNull class]]) {
                self.daoqiTime.text=@"未确定";
            }else{
                NSDate  *date3 = [NSDate dateWithTimeIntervalSince1970:[daoqiStr integerValue]/1000];
                self.daoqiTime.text=[formatter stringFromDate:date3];
            }
            
        }
            break;
        case 7:
        {
            self.huankuanStpe.text=@"已流标";
            self.qixititleLab.text=@"流标时间";
            self.projectstateView.backgroundColor=RGB(0x7A90B3);
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"lossTime"]];
            if (qixiStr==nil||[qixiStr isEqualToString:@""]||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            
            self.calendelBtn.hidden=YES;
            self.topHeightCos.constant=106;
            self.daoqititleLab.hidden=YES;
            self.daoqiTime.hidden=YES;
        }
            break;
        case 8:
        {
            self.huankuanStpe.text=@"回款中";
            self.calendelBtn.hidden=NO;
            self.projectstateView.backgroundColor=RGB(0x3379EA);
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"interestTime"]];
            if ([qixiStr isEqualToString:@""]||qixiStr==nil||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            NSString *daoqiStr=[CommonTools convertToStringWithObject:resuledata[@"repTime"]];
            if (daoqiStr==nil||[daoqiStr isEqualToString:@""]||[daoqiStr isKindOfClass:[NSNull class]]) {
                self.daoqiTime.text=@"未确定";
            }else{
                NSDate  *date3 = [NSDate dateWithTimeIntervalSince1970:[daoqiStr integerValue]/1000];
                self.daoqiTime.text=[formatter stringFromDate:date3];
            }
        }
            break;
        case 9:
        {
            self.huankuanStpe.text=@"已结清";
            self.qixititleLab.text=@"结清时间";
            self.projectstateView.backgroundColor=RGB(0x7A90B3);
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"settleTime"]];
            if (qixiStr ==nil ||[qixiStr isEqualToString:@""]||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            self.topHeightCos.constant=106;
            self.daoqititleLab.hidden=YES;
            self.daoqiTime.hidden=YES;
            self.calendelBtn.hidden=NO;
        }
            break;
        case 10:
        {
            self.huankuanStpe.text=@"回款逾期";
            self.projectstateView.backgroundColor=RGB(0xFF2C2C);
            NSString *qixiStr=[CommonTools convertToStringWithObject:resuledata[@"interestTime"]];
            if (qixiStr==nil||[qixiStr isEqualToString:@""]||[qixiStr isKindOfClass:[NSNull class]]) {
                self.qixiTime.text=@"未确定";
            }else{
                NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[qixiStr integerValue]/1000];
                self.qixiTime.text=[formatter stringFromDate:date2];
            }
            
            NSString *daoqiStr=[CommonTools convertToStringWithObject:resuledata[@"repTime"]];
            if (daoqiStr==nil||[daoqiStr isEqualToString:@""]||[daoqiStr isKindOfClass:[NSNull class]]) {
                self.daoqiTime.text=@"未确定";
            }else{
                NSDate  *date3 = [NSDate dateWithTimeIntervalSince1970:[daoqiStr integerValue]/1000];
                self.daoqiTime.text=[formatter stringFromDate:date3];
            }
            
            
            self.calendelBtn.hidden=NO;
        }
            break;
        default:
            break;
    }
    self.investMoney.font=[UIFont fontWithName:@"SFUIText-Regular" size:14];
    self.investMoney.text=[NSString stringWithFormat:@"%@元",[CommonTools converFloatForFormatMoney:[[CommonTools convertToStringWithObject:resuledata[@"invPrice"]] doubleValue]]];
    if ([[CommonTools convertFoloatToStringWithObject:resuledata[@"addInterestRate"]] doubleValue]>0) {
        self.yuqiyearRate.text=[NSString stringWithFormat:@"%.1lf%%+%.1lf%%",[[CommonTools convertFoloatToStringWithObject:resuledata[@"interestRate"]] doubleValue],[[CommonTools convertFoloatToStringWithObject:resuledata[@"addInterestRate"]] doubleValue]];

    }else{
        self.yuqiyearRate.text=[NSString stringWithFormat:@"%.1lf%%",[[CommonTools convertFoloatToStringWithObject:resuledata[@"interestRate"]] doubleValue]];

    }
    self.lemtDay.text=[NSString stringWithFormat:@"%@%@",[CommonTools convertToStringWithObject:resuledata[@"term"]],[resuledata[@"termCompany"] integerValue]==1?@"天":@"个月"];
    self.huankuanType.text=[CommonTools convertToStringWithObject:resuledata[@"modeName"]];
    if ([[CommonTools convertToStringWithObject:resuledata[@"couponType"]] integerValue]==1) {
        self.yuqiRate.text=[NSString stringWithFormat:@"%@+%@元",[CommonTools convertFoloatToStringWithObject:resuledata[@"projectProit"]],[CommonTools convertFoloatToStringWithObject:resuledata[@"couponPrice"]]];
    }else{
        self.yuqiRate.text=[NSString stringWithFormat:@"%@元",[CommonTools convertFoloatToStringWithObject:resuledata[@"projectProit"]]];
    }
    if ([resuledata[@"couponr"] isEqualToString:@"无"]) {
        self.couponNumber.text=@"未使用";
    }else{
        self.couponNumber.text=resuledata[@"couponr"];
    }
//    cutOutCGFloatDecimal
    if ([resuledata[@"projectStatus"]integerValue]==5) {//募集中的时候
        [self.daishouMoney floatformatNumber:[CommonTools convertFoloatToStringWithObject:resuledata[@"invPrice"]] andSubText:@""];
    }else{
        [self.daishouMoney floatformatNumber:[CommonTools convertFoloatToStringWithObject:resuledata[@"collectPrice"]] andSubText:@""];
    }
    if ([resuledata[@"projectStatus"]integerValue]==7) {//已流标的时候
        [self.yishouMoney floatformatNumber:[CommonTools convertFoloatToStringWithObject:resuledata[@"invPrice"]] andSubText:@""];
    }else{
        [self.yishouMoney floatformatNumber:[CommonTools convertFoloatToStringWithObject:resuledata[@"receivedPrice"]] andSubText:@""];
    }
    
    
    self.daishoushouyiLab.text=[CommonTools convertFoloatToStringWithObject:resuledata[@"collectProit"]];
    self.yishoushouyi.text=[CommonTools convertFoloatToStringWithObject:resuledata[@"receivedProit"]];
    self.projectId=[CommonTools convertToStringWithObject:resuledata[@"projectId"]];
}
#pragma mark --查看项目详情
- (IBAction)clcikProjectDetail:(id)sender {
    if (self.projectId&&![self.projectId isEqualToString:@""]&&![self.projectId isKindOfClass:[NSNull class]]) {
        ProjectDetailVC *projectVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ProjectDetailVC class])];
        projectVc.projectId=self.projectId;
        [self.navigationController pushViewController:projectVc animated:YES];
    }else{
        
    }
}
#pragma mark --查看项目日历
- (IBAction)seeprojectDate:(id)sender {
    
    ProjectCalendarVController *calendarVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ProjectCalendarVController class])];
    calendarVc.projectId=self.projectId;
    calendarVc.investId=self.investId;
    [self.navigationController pushViewController:calendarVc animated:YES];
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
