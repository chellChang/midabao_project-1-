//
//  questlistViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "questlistViewModel.h"
#import "questModel.h"
@implementation questlistViewModel
-(instancetype)init{
    self=[super initWithMethod:@"questList"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"problemList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        questModel *model=[questModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
