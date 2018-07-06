//
//  InvitefriendModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/22.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvitefriendModel.h"

@implementation InvitefriendModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _totalAssets=[CommonTools converFloatForFormatMoney:[[CommonTools convertFoloatToStringWithObject:dic[@"totalAssets"]] doubleValue]];
    _balance=[CommonTools converFloatForFormatMoney:[[CommonTools convertFoloatToStringWithObject:dic[@"balance"]] doubleValue]];
    return YES;
}
@end
