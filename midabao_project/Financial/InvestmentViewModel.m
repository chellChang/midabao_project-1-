
//
//  InvestmentViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvestmentViewModel.h"
#import "investmentModel.h"
@implementation InvestmentViewModel
-(instancetype)init{
    self=[super initWithMethod:@"investmentList"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"userInvestmentList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        investmentModel *model=[investmentModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
