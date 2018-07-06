//
//  findListModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/6.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "findListModel.h"

@implementation findListModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSNumber *statetimestamp = dic[@"beginTime"];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    if (statetimestamp==nil||[statetimestamp isKindOfClass:[NSNull class]]) {
        _beginTime=@"待确定";
        _actBeginTime=nil;
    }else{
        _actBeginTime = [NSDate dateWithTimeIntervalSince1970:[statetimestamp integerValue]/1000];
        _beginTime=[formatter stringFromDate:_actBeginTime];
    }
    
    NSNumber *endtimestamp = dic[@"endTime"];
    if(endtimestamp==nil||[endtimestamp isKindOfClass:[NSNull class]]){
        _endTimes=@"待确定";
        _actEndTime=nil;
    }else{
        _actEndTime = [NSDate dateWithTimeIntervalSince1970:[endtimestamp integerValue]/1000];
        _endTimes=[formatter stringFromDate:_actEndTime];
    }
    return YES;
}
@end
