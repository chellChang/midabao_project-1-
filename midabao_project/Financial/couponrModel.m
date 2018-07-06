//
//  couponrModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "couponrModel.h"

@implementation couponrModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *statetimestamp = dic[@"effecTime"];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _effecTime = [NSDate dateWithTimeIntervalSince1970:[statetimestamp integerValue]/1000];
    _couponPrice =[[CommonTools convertFoloatToStringWithObject:dic[@"couponPrice"]] doubleValue];
    return YES;
}
@end
