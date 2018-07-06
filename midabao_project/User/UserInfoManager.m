//
//  UserInfoManager.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UserInfoManager.h"
#define Last_Login_Account @"last_login_account"
static UserInfoManager *userManage=nil;
@interface UserInfoManager()
@property (strong, nonatomic, readwrite) UserInfo  *userInfo;
@end
@implementation UserInfoManager
+(instancetype)shareUserManager{
    if (!userManage) {
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            userManage=[[UserInfoManager alloc] init];
        });
    }
    
    return userManage;
}
// 防止使用alloc开辟空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if(!userManage){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            userManage = [super allocWithZone:zone];
        });
    }
    return userManage;
}
// 防止copy
+ (id)copyWithZone:(struct _NSZone *)zone{
    if(!userManage){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            userManage = [super copyWithZone:zone];
        });
    }
    return userManage;
}

- (BOOL)logined {
    return self.userInfo.userid.length&&self.userInfo.token.length;
}
-(BOOL)ishideproperty{
    return self.userInfo.ishideMyproperty;
}
- (void)logout{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:DID_OPEN_GESTURE];
    [userDefaults setBool:NO forKey:DID_OPEN_TOUCHID];
    [userDefaults synchronize];
    
    [self.userInfo clear];
}
-(void)updateUserInfo:(NSDictionary *)dic{
    [self.userInfo updateUserinfo:dic];
}
- (void)updateLoginInfo:(NSDictionary *)aDic{
    [self.userInfo updateLoginInfo:aDic];
}
-(void)updateUserPhone:(NSDictionary *)dic{
    [self.userInfo updateUserPhone:dic];
}
-(void)updateUserCertified:(NSDictionary *)dic{
    [self.userInfo updateUserCertified:dic];
}
#pragma mark - getter & setter
-(UserInfo *)userInfo{
    if (!_userInfo) {
        _userInfo=[[UserInfo alloc]init];
    }
    return _userInfo;
}


- (void)saveLastAccount {
    
    [[NSUserDefaults standardUserDefaults] setValue:self.userInfo.mobile forKey:Last_Login_Account];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
