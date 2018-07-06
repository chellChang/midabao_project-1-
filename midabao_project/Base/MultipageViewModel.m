//
//  MultipageViewModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/2.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MultipageViewModel.h"

@interface MultipageViewModel ()

@property (assign, nonatomic, readwrite) NSInteger page;

@property (strong, nonatomic, readwrite) NetWorkOperation *operation;

@end

@implementation MultipageViewModel
-(NSInteger)page{
    if (!_page) {
        _page=1;
    }
    return _page;
}
- (instancetype)init {
    self = [super init];
    
    if (self) {
//        _page = 1;
    }
    return self;
}

- (instancetype)initWithMethod:(NSString *)method {
    self = [super init];
    if (self) {
        _method = [method copy];
    }
    return self;
}
+ (instancetype)MultipageViewModelWithMethod:(NSString *)method {
    return [[[self class] alloc] initWithMethod:method];
}

- (void)fetchFirstPageWithParams:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure {
    @weakify(self)
    self.operation = [NetWorkOperation SendRequestWithMethods:self.method params:[self createNewParamsWithPage:1 oldParams:params] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        self.models = [self createModelWithResult:result];
        self.page = 1;
        !success ? : success( task, result);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        !failure ? : failure(task, result, errorDescription);
        
    }];
}

- (void)fetchNextPageWithParams:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure {
    @weakify(self)
    self.operation = [NetWorkOperation SendRequestWithMethods:self.method params:[self createNewParamsWithPage:self.page+1 oldParams:params] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [self.models addObjectsFromArray:[self createModelWithResult:result]];
        self.page += 1;
        !success ? : success( task, result);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        !failure ? : failure(task, result, errorDescription);
    }];
}

- (NSMutableDictionary *)createNewParamsWithPage:(NSInteger)page oldParams:(NSDictionary *)params {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [result setValue:@(page) forKey:@"pageIndex"];
    [result setValue:@10 forKey:@"pageSize"];
    
    return result;
}

- (NSMutableArray *)createModelWithResult:(id)resultData {
    return [NSMutableArray arrayWithArray:resultData[RESULT_DATA]];
}
-(void)configureDateWithResule:(NSArray *)resultData{
//    NSMutableArray *arr=[NSMutableArray arrayWithArray:resultData[RESULT_DATA]];
}

- (void)deleteAllModels {
    
    [self.models  removeAllObjects];
}

- (NSMutableArray *)allModels {
    
    return self.models;
}
@end
