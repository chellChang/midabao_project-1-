

//
//  projectDetailModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "projectDetailModel.h"

@implementation projectDetailModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *statetimestamp = dic[@"startTime"];
//    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _startTime = [NSDate dateWithTimeIntervalSince1970:[statetimestamp integerValue]/1000];
    NSNumber *endtimestamp = dic[@"entTime"];
//    if (![endtimestamp isKindOfClass:[NSNumber class]]) return NO;
    _entTime = [NSDate dateWithTimeIntervalSince1970:[endtimestamp integerValue]/1000];
    
    NSString *strdata=[CommonTools convertToStringWithObject:dic[@"sttrData"]];
//    if (![strdata isKindOfClass:[NSString class]])return NO;
    NSData *resData = [[NSData alloc] initWithData:[strdata dataUsingEncoding:NSUTF8StringEncoding]];
    _sttrData = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    NSString *extendStr=[CommonTools convertToStringWithObject:dic[@"extendData"]];
//    if (![extendStr isKindOfClass:[NSString class]])return NO;
    NSData *resData1 = [[NSData alloc] initWithData:[extendStr dataUsingEncoding:NSUTF8StringEncoding]];
    _extend_data = [NSJSONSerialization JSONObjectWithData:resData1 options:NSJSONReadingMutableLeaves error:nil];
    NSString *images=[CommonTools convertToStringWithObject:dic[@"imags"]];
    if (![images isEqualToString:@""]&&![images isKindOfClass:[NSNull class]]&&images!=nil) {
        _imags=[images componentsSeparatedByString:@","];
    }else{
        _imags=nil;
    }
//    if (![images isKindOfClass:[NSString class]]) return NO;
    
    return YES;
}
@end
