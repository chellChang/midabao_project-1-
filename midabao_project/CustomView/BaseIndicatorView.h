//
//  GifIndicatorView.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/30.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IndicatorMaskType) {
    
    kIndicatorNoMask = 1, 
    kIndicatorMaskContent,  //去掉Navigation bar的高度 仅限于view is Window 的情况
    kIndicatorMaskAll       //整个视图无响应
};


@interface BaseIndicatorView : UIView


//show和hide需要一一对应
+ (void)show;
+ (void)showWithMaskType:(IndicatorMaskType)type;
+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view maskType:(IndicatorMaskType)type;
+ (void)hide;
@end
