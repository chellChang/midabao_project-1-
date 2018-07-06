//
//  UIViewController+NavigationItem.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SELBlock)(__kindof UIViewController *viewController);

#define NavigationBar_Back @"navigationbar_back"
#define NavigationBar_More @"navigationbar_more"

@interface UIViewController (NavigationItem)

@property (copy, nonatomic) SELBlock leftAction;
@property (copy, nonatomic) SELBlock rightAction;
/**
 @brief navigation left bar of image.
 */
- (UIButton *)layoutNavigationLeftButtonWithImage:(UIImage *)image block:(SELBlock)block;

/**
 @brief navigation right bar of image.
 */
- (UIButton *)layoutNavigationRightButtonWithImage:(UIImage *)image block:(SELBlock)block;

/**
 @brief navigation right bar of text.
 */
- (UIButton *)layoutNavigationRightButtonWithTitle:(NSString *)text color:(UIColor *)color block:(SELBlock)block;


- (UIButton *)layoutNavigationButton:(BOOL)left title:(NSString *)text color:(UIColor *)color action:(SEL)action;
@end
