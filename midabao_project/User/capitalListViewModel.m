
//
//  capitalListViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "capitalListViewModel.h"
#import "capitalDetailModel.h"
@implementation capitalListViewModel
-(instancetype)init{
    self=[super initWithMethod:@"translistQuery"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"userTransList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        capitalDetailModel *model=[capitalDetailModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
