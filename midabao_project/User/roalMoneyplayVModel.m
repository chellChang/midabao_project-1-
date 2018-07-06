


//
//  roalMoneyplayVModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/9.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "roalMoneyplayVModel.h"
#import "returnMoneyModel.h"
@implementation roalMoneyplayVModel
-(instancetype)init{
    self=[super initWithMethod:@"replistQuery"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"userRepList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        returnMoneyModel *model=[returnMoneyModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
