//
//  LoginNavigationVController.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "GestureNavigationController.h"
#define LOGIN_NAVIGARION_STORYBOARD_ID @"LoginNavigationVController"
#define LOGIN_STORYBOARD_NAME @"Login"
typedef void (^LoginResult)(BOOL success);
@interface LoginNavigationVController : GestureNavigationController
+ (instancetype)loginNavigationController;

@property (nonatomic, copy) void (^loginResult)(BOOL success);

- (void)dismissLoginSuccess:(BOOL) success completion:(void(^)(void)) completion;

@end
