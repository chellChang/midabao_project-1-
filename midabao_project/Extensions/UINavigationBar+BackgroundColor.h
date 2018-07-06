//
//  UINavigationBar+BackgroundColor.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BarBackgroundColor)

@property (strong, nonatomic) UIView *coverView;

@property (strong, nonatomic) UIImageView *imageView;

/**
 *  转成自定义的背景
 */
- (void)configureNavigationBar;

- (void)setCustomBackgroundColor:(UIColor *)color;
- (void)setCustomShadowColor:(UIColor *)color;
@end
