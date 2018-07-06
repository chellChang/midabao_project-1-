//
//  LoginNavigationVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "LoginNavigationVController.h"
#import "MidabaoApplication.h"
#import "ChangeLoginVController.h"
#import "UserInfoManager.h"
#import "LoginViewController.h"
@interface LoginNavigationVController ()

@end

@implementation LoginNavigationVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (instancetype)loginNavigationController {
    if (![[UserInfoManager shareUserManager].userInfo.mobile isEqualToString:@""]&&[UserInfoManager shareUserManager].userInfo.mobile!=nil&&![[UserInfoManager shareUserManager].userInfo.mobile isKindOfClass:[NSNull class]]) {
        return  [[[MidabaoApplication shareMidabaoApplication] obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID]initWithRootViewController:[[MidabaoApplication shareMidabaoApplication] obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:NSStringFromClass([LoginViewController class])]];
    }
        return  [[[MidabaoApplication shareMidabaoApplication] obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID]initWithRootViewController:[[MidabaoApplication shareMidabaoApplication] obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:NSStringFromClass([ChangeLoginVController class])]];
}


- (void)dismissLoginSuccess:(BOOL) success completion:(void(^)(void)) completion {
    
    if (self.loginResult) {
        self.loginResult( success);
    }
    
    [self dismissViewControllerAnimated:YES completion:completion];
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
