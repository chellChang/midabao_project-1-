//
//  CommonTools.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

+ (UIImage *)singleImageFromColor:(UIColor *)color {
    
    NSParameterAssert(color);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSString *)convertToStringWithObject:(id)object {
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [[MidabaoApplication shareMidabaoApplication].numberFormatter stringFromNumber:object];
    } else if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSSet class]]) {
        return [object description];
    } else if (!object || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return nil;
    }
}
+(NSString *)convertFoloatToStringWithObject:(id)object{
    if (![object isKindOfClass:[NSNull class]]&&object!=nil) {
       return  [NSString stringWithFormat:@"%.2f",[object doubleValue]];
    }else{
        return @"0.00";
    }
}
+ (CGFloat)cutOutCGFloatDecimal:(CGFloat)aFloat preserve:(NSUInteger)decimal {
    
    NSInteger tmpPow = pow(10, decimal);
    
    NSInteger tmpInt = ((aFloat*tmpPow*10) + (aFloat >= 0 ? 5 : -5) )/10; //四舍五入
    CGFloat tmpFloat = (CGFloat)tmpInt/tmpPow;
    
    return tmpFloat;
}

+ (NSString *)completeWebPathWithSubpath:(NSString *)subpath {
    
    return [NSString stringWithFormat:@"%@%@", HostUrl, subpath];
}

+(NSString *)dealDate:(NSString *)date andpreserve:(NSInteger)decimal andType:(NSInteger)type{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (type==1) {
        if (decimal==1) {
             [formatter setDateFormat:@"yyyy.MM.dd"];
        }else if (decimal==2){
             [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        }
    }else if (type==2){
        if (decimal==1) {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }else if (decimal==2){
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[date integerValue]/1000];
    return  [formatter stringFromDate:date1];
}
+(NSString *)converFloatForFormatMoney:(CGFloat)format{
    if (format>0) {
        NSString *str=[NSString stringWithFormat:@"%lf", format];
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        formatter.numberStyle=NSNumberFormatterDecimalStyle;
        [formatter setPositiveFormat:@"###,##0.00"];
        return [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
    }
    return @"0.00";
}

@end
