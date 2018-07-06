//
//  NetWorkOperation.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/2.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//提交的Key
#define Methods @"methods"



//返回信息
#define REQUEST_SUCCESS_CODE 200//请求成功

#define Login_Time_Out_Code 201//登录超时

#define RESULT_DATA  @"data"

#define RESULT_STATUS @"status"


#define RESULT_ERROR @"info"
@interface NetWorkOperation : NSObject{
    NSURLSessionTask *_task;
}
- (NSURLSessionTaskState)state;


+ (NetWorkOperation *)SendRequestWithMethods:(NSString *)methods params:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure;

- (void)cancelFetchOperation;
@end
