
//
//  UserInfo.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UserInfo.h"
#import "TCKeychain.h"
@interface UserInfo()
@property (copy, atomic, readwrite) NSString *userid;
@property (copy, atomic, readwrite) NSString *mobile;
@property (copy, atomic, readwrite) NSString *token;
@property (copy, atomic, readwrite) NSString *realname;
@property (copy, atomic, readwrite) NSString *idcard;
@property (copy, atomic, readwrite) NSString *bankphone;
@property (copy, atomic, readwrite) NSString *banName;
@property (copy, atomic, readwrite) NSString *banCard;

@property (copy,nonatomic,readwrite)NSString *profit;//收益
@property (copy,nonatomic,readwrite)NSString *estimateProfit;//预计收益
@property (copy,nonatomic,readwrite)NSString *totalAssets;//总资产
@property (copy,nonatomic,readwrite)NSString *balance;//账户余额
@property (copy,nonatomic,readwrite)NSString *withdrawalsPrice;//提现金额
@property (copy,nonatomic,readwrite)NSString *investmentPrice;//在投金额

@property (assign, atomic, readwrite) BOOL tradePassword;
@property (assign, atomic, readwrite) BOOL certifierstate;/**< 实名认证 */
@property (assign, atomic, readwrite) BOOL bankcardstate;
@property (assign ,atomic, readwrite) BOOL signState;//是否签到
@property (assign, atomic, readwrite) BOOL isinvest;//是否投资过
@property (assign,nonatomic,readwrite)BOOL ishideMyproperty;
@end
@implementation UserInfo
- (instancetype)init {
    self = [super init];
    
    NSDictionary *userinfoDic = [TCKeychain load:KEY_USER_INFO][KEY_USERINFO_DIC];
    
    if (self) {
        [self resetUserinfo];
        
        if ([userinfoDic isKindOfClass:[NSDictionary class]]) {
            [self updateLoginInfo:userinfoDic];
            [self updateUserinfo:userinfoDic];
            self.ishideMyproperty=[userinfoDic[Key_IsHideMyProperty] boolValue];
        }
    }
    return self;
}
+ (instancetype)userinfo {
    
    return [[UserInfo alloc] init];
}
- (void)clear {
    
    [self resetUserinfo];
    [TCKeychain delete:KEY_USER_INFO];
}
- (void)resetUserinfo {
    
    self.userid = self.token = @"";
    self.certifierstate = self.tradePassword = self.bankcardstate = NO;
}
- (void)updateUserPhone:(NSDictionary *)userInfoDic{
    if (!userInfoDic.count) return;
    self.mobile = [CommonTools convertToStringWithObject:userInfoDic[Key_Mobile]];
    [self saveUserinfo];
}
- (void)updateLoginInfo:(NSDictionary *)loginInfo {
    if (!loginInfo.count) return;
    self.userid = [CommonTools convertToStringWithObject:loginInfo[Key_UserID]];
    self.token  = loginInfo[Key_Token];
    [self saveUserinfo];
}
- (void)updateUserCertified:(NSDictionary *)dic{
    if (!dic.count) return;
    self.realname       = dic[Key_RealName];
    self.idcard         = dic[Key_Idcard];
    [self saveUserinfo];
}
- (void)updateUserinfo:(NSDictionary *)userinfoDic {
    if (!userinfoDic.count) return;
    self.mobile = [CommonTools convertToStringWithObject:userinfoDic[Key_Mobile]];
    self.realname       = userinfoDic[Key_RealName];
    self.idcard         = userinfoDic[Key_Idcard];
    self.tradePassword  = [userinfoDic[Key_Trade_Password_State] boolValue];
    self.bankcardstate  = [userinfoDic[Key_Bankcard_State] boolValue];
    self.signState      = [userinfoDic[Key_Sign_State]boolValue];
    self.isinvest       = [userinfoDic[Key_Invest_State]boolValue];
    self.profit         = userinfoDic[Key_Profit];
    self.estimateProfit = userinfoDic[Key_EstProfit];
    self.totalAssets    = userinfoDic[Key_TotalAss];
    self.balance        = userinfoDic[Key_Balance];
    self.withdrawalsPrice =userinfoDic[Key_WithdrawPrice];
    self.investmentPrice= userinfoDic[Key_InvestPrice];
    
    [self saveUserinfo];
}
- (void)didCertifiedState:(BOOL)state{
    self.certifierstate = state;
    [self saveUserinfo];
}
- (void)didSetupTradePasswordState:(BOOL)state{
    self.tradePassword = state;
    [self saveUserinfo];
}
- (void)didSaveBankcardState:(BOOL)state{
    self.bankcardstate = state;
    [self saveUserinfo];
}
-(void)ddiSaveMypropertyHideState:(BOOL)state{
    self.ishideMyproperty=state;
    [self saveUserinfo];
}
- (void)saveUserinfo {
    
    NSMutableDictionary *userinfo    = [TCKeychain load:KEY_USER_INFO];
    NSMutableDictionary *userinfoDic = nil;
    if ([userinfo[KEY_USERINFO_DIC] isMemberOfClass:[NSMutableDictionary class]]) {
        userinfoDic = userinfo[KEY_USERINFO_DIC];
    } else {
        userinfoDic = [[NSMutableDictionary alloc] init];
    }
    [userinfoDic setValue:self.userid forKey:Key_UserID];
    [userinfoDic setValue:self.mobile forKey:Key_Mobile];
    [userinfoDic setValue:self.token forKey:Key_Token];
    [userinfoDic setValue:self.realname forKey:Key_RealName];
    [userinfoDic setValue:self.idcard forKey:Key_Idcard];
    [userinfoDic setValue:self.bankphone forKey:Key_BankPhone];
    [userinfoDic setValue:self.banName forKey:Key_BankName];
    [userinfoDic setValue:self.banCard forKey:Key_BankCard];
    [userinfoDic setValue:@(self.tradePassword) forKey:Key_Trade_Password_State];
    [userinfoDic setValue:@(self.certifierstate) forKey:Key_Cerifier_State];
    [userinfoDic setValue:@(self.bankcardstate) forKey:Key_Bankcard_State];
    [userinfoDic setValue:@(self.signState) forKey:Key_Sign_State];
    [userinfoDic setValue:@(self.ishideMyproperty) forKey:Key_IsHideMyProperty];
    
    [userinfoDic setValue:self.profit forKey:Key_Profit];
    [userinfoDic setValue:self.estimateProfit forKey:Key_EstProfit];
    [userinfoDic setValue:self.totalAssets forKey:Key_TotalAss];
    [userinfoDic setValue:self.balance forKey:Key_Balance];
    [userinfoDic setValue:self.withdrawalsPrice forKey:Key_WithdrawPrice];
    [userinfoDic setValue:self.investmentPrice forKey:Key_InvestPrice];
    
    [userinfo setValue:userinfoDic forKey:KEY_USERINFO_DIC];
    [TCKeychain save:KEY_USER_INFO data:userinfo];
}
@end
