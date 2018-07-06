//
//  returnMoneyModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/9.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "returnMoneyModel.h"

@implementation returnMoneyModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *huankuanTime=[CommonTools convertToStringWithObject:dic[@"repTime"]];
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[huankuanTime integerValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    if (![huankuanTime isEqualToString:@""]&&![huankuanTime isKindOfClass:[NSNull class]]&&huankuanTime!=nil) {
        _repTime=[formatter stringFromDate:date1];
    }else{
        _repTime=@"";
    }
    NSString *shijiTime=[CommonTools convertToStringWithObject:dic[@"actualRepTime"]];
    NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[shijiTime integerValue]/1000];
    if (shijiTime!=nil&&![shijiTime isEqualToString:@""]&&![shijiTime isKindOfClass:[NSNull class]]) {
        _actualRepTime=[formatter stringFromDate:date2];
    }else{
        _actualRepTime=@"";
    }
    
    return YES;
}
@end
