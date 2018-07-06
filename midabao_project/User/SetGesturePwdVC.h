//
//  SetGesturePwdVC.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/17.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BaseViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
typedef NS_ENUM(NSInteger, GesturePasswordVCType) {
    kGesturePasswordSetting,//设置手势密码
    kGesturePasswordAlter,//修改手势密码
    kGesturePasswordAuth,//验证手势密码
    kGesturePasswordLogin//登录手势密码
};

typedef NS_ENUM(NSInteger, GesturePasswordOperationType) {
    kGesturePasswordOperationSuccess,
    kGesturePasswordOperationFailure,
    kGesturePasswordOperationCancel,
    kGesturePasswordOperationLogout
};
#define GESTURE_PASSWORD_STORYBOARD_ID @"SetGesturePwdVC"
@interface SetGesturePwdVC : BaseViewController
@property (assign, nonatomic, readwrite) GesturePasswordVCType type;

- (void)setCompletionBlock:( void(^)(SetGesturePwdVC*vc, GesturePasswordOperationType type))callBack;

- (void)authTouchIdClick:(id)sender;
@end
