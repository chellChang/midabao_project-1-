//
//  MyInsertSubTabView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "StateTableView.h"
#import "investListViewModel.h"
@protocol MyinsertSubViewDelegate<NSObject>
-(void)didSelectRowWithID:(NSString *)projectId;
@end
@interface MyInsertSubTabView : StateTableView
@property (assign,nonatomic)BOOL needRefirsh;/**<是否需要刷新，默认为Yes*/
@property (strong,nonatomic)investListViewModel *investViewModel;
@property (weak,nonatomic)id<MyinsertSubViewDelegate>Mydelelgate;

-(void)firstRefirshUIWithView;

/**
 初始化

 @param state 0全部 1 回款中 2募集中 3已结清
 @return class
 */
+(MyInsertSubTabView *)contentTableviewWithState:(NSInteger)state;
@end
