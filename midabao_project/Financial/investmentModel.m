//
//  investmentModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "investmentModel.h"

@implementation investmentModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *statetimestamp = dic[@"invTime"];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _invTime = [NSDate dateWithTimeIntervalSince1970:[statetimestamp integerValue]/1000];
    return YES;
}
@end
