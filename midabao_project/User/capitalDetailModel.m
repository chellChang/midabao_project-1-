//
//  capitalDetailModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "capitalDetailModel.h"

@implementation capitalDetailModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _capitaloperator=[[CommonTools convertToStringWithObject:dic[@"operator"]] integerValue];
    NSString *endtimestr=[CommonTools convertToStringWithObject:dic[@"endTime"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy.MM.dd"];
    if (endtimestr==nil||[endtimestr isEqualToString:@""]||[endtimestr isKindOfClass:[NSNull class]]) {
        _endTme=@"未确定";
        _endTimeDetail=@"未确定";
    }else{
        NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[endtimestr integerValue]/1000];
        _endTme=[formatter stringFromDate:date1];
        _endTimeDetail=[formatter2 stringFromDate:date1];
    }
    
    NSString *createdtimestr=[CommonTools convertToStringWithObject:dic[@"created"]];
    NSDate  *date2 = [NSDate dateWithTimeIntervalSince1970:[createdtimestr integerValue]/1000];
    _created=[formatter stringFromDate:date2];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM.dd"];
    _crateTime=[formatter1 stringFromDate:date2];
    _crateTimeDetail=[formatter2 stringFromDate:date2];
    NSString *estiTimestr=[CommonTools convertToStringWithObject:dic[@"estiTime"]];
    if (estiTimestr==nil||[estiTimestr isEqualToString:@""]||[estiTimestr isKindOfClass:[NSNull class]]) {
        _estiTime=@"未确定";
    }else{
        NSDate  *date3 = [NSDate dateWithTimeIntervalSince1970:[estiTimestr integerValue]/1000];
        _estiTime=[formatter2 stringFromDate:date3];
    }
   
    return YES;
}
@end
