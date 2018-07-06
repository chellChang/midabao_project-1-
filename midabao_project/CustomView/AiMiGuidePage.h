//
//  FirstEnterLinQi.h
//  wujin-buyer
//
//  Created by wujin  on 15/2/6.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AiMiGuidePage : UIView

@property (strong, nonatomic, readonly) UIPageControl *pageControl;
@property (strong, nonatomic, readonly) UIScrollView *scroll;
@property (strong, nonatomic, readonly) UIButton *enter;

/**
 *  根据设定的条件判断是否需要引导页
 *
 *  @return 是否需要引导页
 */
+ (BOOL)canShow;

/**
 *  直接显示 引导页 ，引导页直接在这个函数内部设置
 *
 */
+ (void)showWithComplete:( void(^)() ) complete;
+ (void)showInView:(UIView *)view complete:( void(^)() ) complete;
@end
