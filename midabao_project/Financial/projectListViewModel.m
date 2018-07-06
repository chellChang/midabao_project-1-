//
//  projectListViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/25.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "projectListViewModel.h"
#import "ProjectListModel.h"
@implementation projectListViewModel
-(instancetype)init{
    self=[super initWithMethod:@"queryList"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"projectList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProjectListModel *model=[ProjectListModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end
