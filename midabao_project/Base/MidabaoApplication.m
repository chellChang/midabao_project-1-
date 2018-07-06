//
//  MidabaoApplication.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MidabaoApplication.h"
#import "TCKeychain.h"
#import "WXApi.h"
#define WXAPPID @"wxf82426270ea154f2"
#define UMAPPKEY @"59cf2b94ae1bf82218000018"
#import <UMMobClick/MobClick.h>
//@"d5e8b163b2e6e7688f353645a67f72c4"

@implementation MidabaoApplication
#pragma mark - Public Method
+ (instancetype)shareMidabaoApplication {
    
    static MidabaoApplication *result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [[MidabaoApplication alloc] init];
    });
    
    return result;
}
- (void)initializeApplicationWithOptions:(NSDictionary *)launchOptions{
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ DID_OPEN_GESTURE: @NO, DID_OPEN_TOUCHID: @NO}];
    
    if ([self isNewInstall] || [self isUpdateVersion]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:[self isNewInstall] || [[NSBundle mainBundle].infoDictionary[APP_GUIDE_PAGE_KEY] boolValue] forKey:Need_Guide_Page];
        [self clearOldVersionData];
        //此方法使用了 [[NSUserDefaults standardUserDefaults] synchronize]
        [self updateAppLasestVersion];
    }

    [WXApi registerApp:WXAPPID];
    UMAnalyticsConfig *cofig=[[UMAnalyticsConfig alloc]init];
    cofig.appKey=UMAPPKEY;
    [MobClick startWithConfigure:cofig];
    [MobClick setAppVersion:CurrentVersion];
}
- (NSString *)pathForCachesWithFileName:(NSString *)fileName {
    
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];;
}
- (id)obtainControllerForStoryboard:(NSString *)name controller:(NSString *)VCIdentity {
    
    NSParameterAssert(VCIdentity);
    if (nil == name || nil == VCIdentity) {
        return nil;
    } else {
        
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:VCIdentity];
    }
}

- (nullable id)obtainControllerForMainStoryboardWithID:(NSString *)VCIdentity {
    
    return [self obtainControllerForStoryboard:@"Main" controller:VCIdentity];
}
- (BOOL)haveGesturePassword{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_GESTURE]) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            [NetWorkOperation SendRequestWithMethods:@"getQuotes" params:@{} success:^(NSURLSessionTask *task, id result) {
                [[NSUserDefaults standardUserDefaults] setValue:result[RESULT_DATA][@"something"] forKey:QuotesLanguage];
                [[NSUserDefaults standardUserDefaults]synchronize];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                
            }];
        });
        return [[TCKeychain load:KEY_USER_INFO][KEY_USER_GESTUREPASSWORD] length];
    } else {
        return NO;
    }
}
#pragma mark - Private Method
- (BOOL)isNewInstall {
    
    return ![[NSUserDefaults standardUserDefaults] objectForKey:VERSION_KEY];
}
- (BOOL)isUpdateVersion {
    
    return ![[[NSUserDefaults standardUserDefaults] objectForKey:VERSION_KEY] isEqualToString:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY]];
}
- (void)clearOldVersionData {
    
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForCachesWithFileName:bannerPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForCachesWithFileName:recommendPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForCachesWithFileName:productsPath] error:nil];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)updateAppLasestVersion {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY] forKey:VERSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - getter
- (NSNumberFormatter *)numberFormatter {
    
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.positiveFormat = @"0.##";
    }
    return _numberFormatter;
}
@end
