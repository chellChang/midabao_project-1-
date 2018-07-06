//
//  UILabel+Format.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/4.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Format)
-(void)formatNumber:(NSString *)number andsubText:(NSString *)subText;

/**
 千分位分割符加富文本(range是subtext的长度)

 @param number 需要分割的字符串
 @param subText 需要拼接的字符串
 @param attrs 富文本样式
 */
-(void)formatNumber:(NSString *)number andsubText:(NSString *)subText andAttribute:(NSDictionary<NSString *, id> *)attrs;



/**
 float类型保留两位小数

 @param number 要分割的字符串
 @param subText 需要拼接的字符串
 */
-(void)floatformatNumber:(NSString *)number andSubText:(NSString *)subText;
@end
