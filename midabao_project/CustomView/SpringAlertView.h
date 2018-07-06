//
//  SpringAlertView.h
//  wujin-tourist
//
//  Created by wujin  on 15/7/14.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpringAlertView : UIView

@property (strong, nonatomic, readonly) NSString *message;

+ (void)showMessage:(NSString *)message;
+ (void)showInWindow:(UIWindow *)window message:(NSString *)message;
@end
