//
//  NetWorkOperation.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/2.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//
#import "NetWorkOperation.h"
#import "NSString+ExtendMethod.h"
#define  AppId     @"appId"
#define  AppSecret @"appSecret"
#define  ApiName   @"apiName"
#define  TimeStamp @"timeStamp"
#define  ParamMap  @"paramMap"
#define  Sign      @"sign"
#define  APPTYPE   @"ios"
#define APPUSERID  @"userId"
#define APPTOKEN   @"token"
#define APPIDVALUE @"0d0190a2d1b2470e8e44726c56402bb0"
#import "UserInfoManager.h"




@implementation NetWorkOperation
- (void)cancelFetchOperation {
    
    if (NSURLSessionTaskStateRunning != _task.state) return;
    [_task cancel];
}
- (NSURLSessionTaskState)state {
    return _task.state;
}

+ (NetWorkOperation *)SendRequestWithMethods:(NSString *)methods params:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure{
    NetWorkOperation *operation=[[NetWorkOperation alloc]init];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    operation->_task = [manager POST:HostUrl parameters:[self PrepareParamsWithMethed:methods oldParams:params] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self parseResult:responseObject operation:task success:success failure:failure requestTager:methods];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        if (failure) failure(task, nil, -999 == error.code ? nil : NSLocalizedString(@"err_network", nil));
    }];
    return operation;
}
+ (void)parseResult:(id)result operation:(__kindof NSObject *)operation success:( void(^)(__kindof NSObject *operation,id result) )success failure:( void(^)(__kindof NSObject *operation, id result, NSString *errorDescription) )failure requestTager:(NSString *)mothed {
    
    if ((REQUEST_SUCCESS_CODE == [result[RESULT_STATUS] intValue])) {//请求成功
        
        !success ? :success(operation, result);
    }else {//请求失败
        if (Login_Time_Out_Code == [result[RESULT_STATUS] intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginTimeout object:nil];
        }
        
        !failure ? : failure(operation, result, Login_Time_Out_Code == [result[RESULT_STATUS] intValue] ? nil : result[RESULT_ERROR]!=nil&&result[RESULT_ERROR]!=NULL&&![result[RESULT_ERROR]isKindOfClass:[NSNull class]]?result[RESULT_ERROR]:@"未知错误");//返回错误信息
        
    }
}
+ (NSDictionary *)PrepareParamsWithMethed:(NSString *)method oldParams:(NSDictionary *)oldParams {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    [result setValue:[self getCurrentTimestamp] forKey:TimeStamp];
    [result setValue:APPIDVALUE forKey:AppId];
    [result setValue:APPSECRETVALUE forKey:AppSecret];
    method=[[[self presetParamete]valueForKey:method]valueForKey:Methods];
    [result setValue:method forKey:ApiName];
    
    [result setValue:oldParams forKey:ParamMap];
    NSString *signStr=[[[self dictionaryToDesJson:result] MD5Encryption] uppercaseString];
    [result setValue:signStr forKey:Sign];
    if (oldParams) {
        NSString *paramsStr=[self dictionaryToJson:oldParams];
        [result setValue:paramsStr forKey:ParamMap];
    }
    [result removeObjectForKey:AppSecret];
    [result setValue:[UserInfoManager shareUserManager].userInfo.userid forKey:APPUSERID];
    [result setValue:[UserInfoManager shareUserManager].userInfo.token forKey:APPTOKEN];
    NSLog(@"--res:%@",result);
    return result;
}

+ (NSDictionary *)presetParamete {
    
    static NSDictionary *result = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        result = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ParameterUrl.plist" ofType:nil]];
    });
    
    return [result copy];
}
//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    NSString *jsonString=[[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonString;
}
#pragma mark --获取当前时间的13位时间戳
+(NSString*)getCurrentTimestamp{
    NSDate *datetime = [NSDate date];
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    NSString *nowTimeStr=[NSString stringWithFormat:@"%lld",totalMilliseconds];
    return nowTimeStr;
}

#pragma mark --排序得到排序过的字符串
+(NSString*)dictionaryToDesJson:(NSDictionary *)dic
{
    NSMutableString *contentString =[NSMutableString string];
    NSArray *keys=[dic allKeys];
    NSArray *sortArray=[keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortArray) {
        if (![categoryId isEqualToString:TimeStamp]) {
            if ([categoryId isEqualToString:ParamMap]) {
                NSError *error=nil;
                NSDictionary *mapdic=[dic objectForKey:ParamMap];
//                NSArray *subKeys=[mapdic allKeys];
//                NSArray *subSortArray=[subKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                    return [obj1 compare:obj2 options:NSNumericSearch];
//                }];
//                NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
//                for (NSString *subKey in subSortArray) {
//                    [mutDic setValue:[mapdic valueForKey:subKey] forKey:subKey];
//                }
                
                NSData *jsonData=[NSJSONSerialization dataWithJSONObject:mapdic options:NSJSONWritingPrettyPrinted error:&error];
                NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
                NSString *jsonString=[[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
                jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                jsonString=[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
                jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];//去掉url上的转义字符
                [contentString appendFormat:@"%@=%@&",ParamMap,jsonString];
            }else{
                [contentString appendFormat:@"%@=%@&",categoryId,[dic valueForKey:categoryId]];
            }
        }
        
        
    }
    //最后一个字段直接拼接
    //添加key字段
    [contentString appendFormat:@"%@=%@",TimeStamp, [dic objectForKey:TimeStamp]];
    NSString *strUrl1 = [contentString stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl1 = [strUrl1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    strUrl1 = [strUrl1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"--str:%@",strUrl1);
    return strUrl1;
}

@end
