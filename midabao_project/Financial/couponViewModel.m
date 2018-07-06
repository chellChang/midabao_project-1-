//
//  couponViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "couponViewModel.h"
#import "couponrModel.h"
@implementation couponViewModel
-(instancetype)init{
    self=[super initWithMethod:@"querycouponr"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"couponrList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        couponrModel *model=[couponrModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
