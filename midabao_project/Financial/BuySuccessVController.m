//
//  BuySuccessVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/4.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BuySuccessVController.h"

@interface BuySuccessVController ()
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

@end

@implementation BuySuccessVController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        @strongify(self)
        !self.closeDown?:self.closeDown();
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if (self.showtype==1) {
        self.fourView.hidden=YES;
        self.threeView.hidden=NO;
    }else if (self.showtype==2){
        self.fourView.hidden=NO;
        self.threeView.hidden=YES;
    }
    // Do any additional setup after loading the view.
}
#pragma mark --点击确认
- (IBAction)buysuccessClick:(UIButton *)sender {
    !self.closeDown?:self.closeDown();
    [self dismissViewControllerAnimated:YES completion:nil];
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
