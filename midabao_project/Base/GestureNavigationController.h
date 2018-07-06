//
//  GestureNavigationController.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureNavigationController : UINavigationController<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (assign, nonatomic) BOOL gestureEnabled;
@end
