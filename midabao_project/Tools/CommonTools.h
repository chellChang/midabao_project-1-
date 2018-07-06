//
//  CommonTools.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTools : NSObject

/**
 *  生成一张1*1的纯色图片
 *
 *  @param color 生成图片的颜色
 *
 *  @return 生成的图片
 */
+ (UIImage *)singleImageFromColor:(UIColor *)color;

/**
 *  将object转化为NSString *
 *
 *  @param object 需要转化的对象
 *
 *  @return 返回完成的值
 */
+ (NSString *)convertToStringWithObject:(id)object;


+(NSString *)convertFoloatToStringWithObject:(id)object;

/**
 *  将CGFloat 强制保留decimal小数位
 *
 *  @param aFloat  需要处理的CGFloat
 *  @param decimal 需要保留的小数点的位数
 *
 *  @return 处理过后的新值
 */
+ (CGFloat)cutOutCGFloatDecimal:(CGFloat)aFloat preserve:(NSUInteger)decimal;

+ (NSString *)completeWebPathWithSubpath:(NSString *)subpath;

/**
 时间转换

 @param date 时间戳
 @param decimal 精确度1.到天2.到秒
 @param type 时间格式1.。2-
 @return 时间字符串
 */
+(NSString *)dealDate:(NSString *)date andpreserve:(NSInteger)decimal andType:(NSInteger)type;

/**
 格式化数字

 @param format 需要格式的数字
 @return 然后格式化后的数字
 */
+(NSString *)converFloatForFormatMoney:(CGFloat)format;
@end
