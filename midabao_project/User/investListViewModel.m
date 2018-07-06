
//
//  investListViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "investListViewModel.h"
#import "myinvestlistModel.h"
@implementation investListViewModel
-(instancetype)init{
    self=[super initWithMethod:@"investmentlistQuery"];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)createModelWithResult:(id)resultData{
    NSMutableArray *result=[NSMutableArray array];
    [resultData[RESULT_DATA][@"userInvestmentList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        myinvestlistModel *model=[myinvestlistModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    return result;
}

//直接赋值
-(void)configureDateWithResule:(NSArray *)resultData{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    [resultData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        myinvestlistModel *model=[myinvestlistModel yy_modelWithJSON:obj];
        [result addObject:model];
    }];
    self.models=result;
}
@end
