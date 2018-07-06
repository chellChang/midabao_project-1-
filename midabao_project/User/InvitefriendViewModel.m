//
//  InvitefriendViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/22.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvitefriendViewModel.h"
#import "InvitefriendModel.h"
@implementation InvitefriendViewModel
-(instancetype)init{
    self=[super initWithMethod:@"userfriendQuery"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"uiList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        InvitefriendModel *model=[InvitefriendModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}
@end

