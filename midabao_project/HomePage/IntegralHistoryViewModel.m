

//
//  IntegralHistoryViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/25.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "IntegralHistoryViewModel.h"
#import "IntegralModel.h"
@implementation IntegralHistoryViewModel
-(instancetype)init{
    self=[super initWithMethod:@"integralhistory"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"historyList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IntegralModel *model=[IntegralModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;

}
@end
