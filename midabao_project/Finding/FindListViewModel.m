
//
//  FindListViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/6.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FindListViewModel.h"
#import "findListModel.h"
@implementation FindListViewModel
-(instancetype)init{
    self=[super initWithMethod:@"articlefind"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"articleList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        findListModel *model=[findListModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
    
}
@end
