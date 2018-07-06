//
//  MultipageViewModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/2.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "NetWorkOperation.h"

@interface MultipageViewModel : NSObject

@property (assign, nonatomic, readonly) NSInteger page;
@property (strong, nonatomic, readonly) NetWorkOperation *operation;
@property (strong, nonatomic) NSMutableArray *allModels;
@property (strong, nonatomic) NSMutableArray *models;
@property (copy, nonatomic) NSString *method;

- (void)fetchFirstPageWithParams:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure;

- (void)fetchNextPageWithParams:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure;


- (instancetype)initWithMethod:(NSString *)method;
+ (instancetype)MultipageViewModelWithMethod:(NSString *)method;

/**
 *  交由子类实现
 */
- (NSMutableArray *)createModelWithResult:(id)resultData;

/**
 *直接调用赋值不需要通过调用刷新方法

 @param resultData 请求结果
 */
-(void)configureDateWithResule:(NSArray *)resultData;

- (void)deleteAllModels;

@end
