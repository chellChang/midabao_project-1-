



//
//  RechargeOrWithdrawSuccessVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/13.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "RechargeOrWithdrawSuccessVC.h"

@interface RechargeOrWithdrawSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *deatialLab;

@end

@implementation RechargeOrWithdrawSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        @strongify(self)
        !self.closeDown?:self.closeDown();
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if (self.currentType==1) {
        self.title=@"充值提交";
        self.titleLab.text=@"充值申请已提交";
        self.deatialLab.text=@"您的充值申请已提交，请到个人中心查看。如遇到问题，请拨打客服电话400-852-0612";
    }else{
        self.title=@"提现提交";
        self.titleLab.text=@"提现申请已提交";
        self.deatialLab.text=@"您的提现申请已提交，根据银行的出款时间，最迟3个工作日内到账。";
    }
    // Do any additional setup after loading the view.
}
- (IBAction)clickcomibiton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        !self.closeDown?:self.closeDown();
    }];
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
