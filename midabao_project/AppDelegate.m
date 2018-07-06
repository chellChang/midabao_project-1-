//
//  AppDelegate.m
//  midabao_project
//
//  Created by Yuanin2 on 2017/7/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "AppDelegate.h"
#import "MidabaoTabBar.h"
#import "MidabaoApplication.h"
#import "SetGesturePwdVC.h"
#import "GestureNavigationController.h"
#import "LoginNavigationVController.h"
#import "UserInfoManager.h"
#import "WXApi.h"
#import "MidabaoApplication.h"
#import "AiMiGuidePage.h"
#import "UserInfoManager.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.rootViewController = [self chooseTheRootViewController];
    [self.window makeKeyAndVisible];
    [[MidabaoApplication shareMidabaoApplication]initializeApplicationWithOptions:launchOptions];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if ([AiMiGuidePage canShow]) {
        [AiMiGuidePage showWithComplete:^{
            if ([self.window.rootViewController isKindOfClass:[GestureNavigationController class]]) {
                GestureNavigationController *navc=(GestureNavigationController *)self.window.rootViewController;
                if ([[navc.viewControllers firstObject]isKindOfClass:[SetGesturePwdVC class]]) {
                    [(SetGesturePwdVC *)[navc.viewControllers firstObject] authTouchIdClick:nil];
                }
            }
        }];
    } else {
        if ([self.window.rootViewController isKindOfClass:[GestureNavigationController class]]) {
            GestureNavigationController *navc=(GestureNavigationController *)self.window.rootViewController;
            if ([[navc.viewControllers firstObject]isKindOfClass:[SetGesturePwdVC class]]) {
                [(SetGesturePwdVC *)[navc.viewControllers firstObject] authTouchIdClick:nil];
            }
        }
    }
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginTimeout object:nil] subscribeNext:^(id x) {
        [AlertViewManager showInViewController:self.window.rootViewController title:@"提示" message:@"登录超时，是否重新登录" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            [[UserInfoManager shareUserManager] logout];
            self.window.rootViewController = [self MiDaBaoTBCWithNeedLogin:1 == buttonIndex];
            
        } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"重新登录", nil];
    }];
    return YES;
}

- (UIViewController *)chooseTheRootViewController {
    
    if ([UserInfoManager shareUserManager].logined&&[[MidabaoApplication shareMidabaoApplication]haveGesturePassword]) {//开启手势密码
        SetGesturePwdVC *pwdVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SetGesturePwdVC class])];
        pwdVc.type=kGesturePasswordLogin;
        @weakify(self)
        [pwdVc setCompletionBlock:^(SetGesturePwdVC *vc, GesturePasswordOperationType type) {
            @strongify(self)
            self.window.rootViewController=[self MiDaBaoTBCWithNeedLogin:kGesturePasswordOperationSuccess != type];
        }];
         GestureNavigationController*navc=[[GestureNavigationController alloc]initWithRootViewController:pwdVc];
        return navc;
    }
    return [self MiDaBaoTBCWithNeedLogin:NO];
    
}
- (UIViewController *)MiDaBaoTBCWithNeedLogin:(BOOL)needLogin {
    
    if (needLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Normal_Animation_Duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        });
    }
    
    return [[MidabaoApplication shareMidabaoApplication] obtainControllerForMainStoryboardWithID:NSStringFromClass([MidabaoTabBar class])];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
#pragma mark ---微信分享的回调
- (void)onResp:(BaseResp *)resp {
    //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    //使用UIAlertView 显示回调信息
    if (sendResp.errCode==WXSuccess) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinSeccessCallBack" object:nil];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
