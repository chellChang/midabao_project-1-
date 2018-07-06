
//
//  myinvestlistModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "myinvestlistModel.h"

@implementation myinvestlistModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _projectId=[CommonTools convertToStringWithObject:dic[@"id"]];
    _residuedays=[CommonTools convertToStringWithObject:dic[@"days"]];
     NSString *invTimestr=[CommonTools convertToStringWithObject:dic[@"invTime"]];
    NSNumber *investTime = [NSNumber numberWithInteger:[invTimestr integerValue]];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _invTime = [NSDate dateWithTimeIntervalSince1970:[investTime integerValue]/1000];
    NSString *lostimestr=[CommonTools convertToStringWithObject:dic[@"lossTime"]];
    NSNumber *losssTime =[NSNumber numberWithInteger:[lostimestr integerValue]];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    if (lostimestr!=nil&&![lostimestr isKindOfClass:[NSNull class]]&&![lostimestr isEqualToString:@""]) {
        _lossTime = [NSDate dateWithTimeIntervalSince1970:[losssTime integerValue]/1000];
    }else{
        _lossTime = nil;
    }
    
    
    NSNumber *settTime =[NSNumber numberWithInteger:[[CommonTools convertToStringWithObject:dic[@"settleTime"]]integerValue]] ;
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _settleTime = [NSDate dateWithTimeIntervalSince1970:[settTime integerValue]/1000];
    NSNumber *endTime = [NSNumber numberWithInteger:[[CommonTools convertToStringWithObject:dic[@"entTime"]]integerValue]];
    //    if (![statetimestamp isKindOfClass:[NSNumber class]]) return NO;
    _entTime = [NSDate dateWithTimeIntervalSince1970:[endTime integerValue]/1000];
    
    _repTime=[NSDate dateWithTimeIntervalSince1970:[[CommonTools convertToStringWithObject:dic[@"repTime"]] integerValue]/1000];
    
    if (_repDays!=nil&&![_repDays isKindOfClass:[NSNull class]]) {
        if (_repDays<0) {
            _repDays=0;
        }
    }
    return YES;
}
@end
