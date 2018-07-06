//
//  BankInfoModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/13.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BankInfoModel.h"

@implementation BankInfoModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSInteger value1=[[CommonTools convertFoloatToStringWithObject:dic[@"eachPrice"]] integerValue];
    _eachPrice=[NSString stringWithFormat:@"%.ld",value1/10000];
    
    NSInteger value2=[[CommonTools convertFoloatToStringWithObject:dic[@"everydayPrice"]] integerValue];
    _everydayPrice=[NSString stringWithFormat:@"%.ld",value2/10000];
    return YES;
}
@end
