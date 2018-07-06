
//
//  AccountpropertyVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "AccountpropertyVC.h"
#import "UserInfoManager.h"
#import "UILabel+Format.h"
@interface AccountpropertyVC ()
@property (weak, nonatomic) IBOutlet UILabel *myproperty;
@property (weak, nonatomic) IBOutlet UILabel *principalLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *tixianzhongLab;
@property (weak, nonatomic) IBOutlet UILabel *explanearnings;
@property (weak, nonatomic) IBOutlet UILabel *daiearnings;
@property (weak, nonatomic) IBOutlet UILabel *yiearnings;

@end

@implementation AccountpropertyVC
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
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    [self.myproperty floatformatNumber:[UserInfoManager shareUserManager].userInfo.totalAssets andSubText:@""];
    [self.principalLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.investmentPrice andSubText:@""];
    [self.balanceLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.balance andSubText:@""];
    [self.tixianzhongLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.withdrawalsPrice andSubText:@""];
    [self.daiearnings floatformatNumber:[UserInfoManager shareUserManager].userInfo.estimateProfit andSubText:@""];
    [self.yiearnings floatformatNumber:[UserInfoManager shareUserManager].userInfo.profit andSubText:@""];
    [self.explanearnings floatformatNumber:[NSString stringWithFormat:@"%.2f",([[UserInfoManager shareUserManager].userInfo.profit doubleValue]+[[UserInfoManager shareUserManager].userInfo.estimateProfit doubleValue])] andSubText:@""];
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
