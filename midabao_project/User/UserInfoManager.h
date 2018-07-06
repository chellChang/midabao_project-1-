//
//  UserInfoManager.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
static NSString *const UserLoginTimeout = @"User_Login_Timeout";
@interface UserInfoManager : NSObject
@property (strong, nonatomic, readonly) UserInfo *userInfo;/**<用户信息 */
@property (assign, nonatomic, readonly) BOOL logined;
@property (assign, nonatomic, readonly) BOOL ishideproperty;
+(instancetype)shareUserManager;
/**
 *  退出登录
 */
- (void)logout;

- (void)updateLoginInfo:(NSDictionary *)aDic;

-(void)updateUserInfo:(NSDictionary *)dic;

-(void)updateUserPhone:(NSDictionary *)dic;


-(void)updateUserCertified:(NSDictionary *)dic;
@end
