//
//  UserInfo.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Key_UserID               @"userId"
#define Key_Mobile               @"mobile"
#define Key_Token                @"token"
#define Key_Bankcard_State       @"is_bind_bank"//是否绑卡
#define Key_Cerifier_State       @"is_attestation"//是否实名认证
#define Key_Trade_Password_State @"is_tradepass"//是否设置交易密码
#define Key_Sign_State           @"is_sign"
#define Key_Invest_State         @"isinvest"
#define Key_RealName             @"realName"
#define Key_Idcard               @"idcard"
#define Key_BankPhone            @"Bankphone"
#define Key_BankName             @"bankname"
#define Key_BankCard             @"bankcard"

#define Key_Profit               @"profit"
#define Key_EstProfit            @"estimateProfit"
#define Key_TotalAss             @"totalAssets"
#define Key_Balance              @"balance"
#define Key_WithdrawPrice        @"withdrawalsPrice"
#define Key_InvestPrice          @"investmentPrice"
#define Key_IsHideMyProperty     @"ishideMyproperty"


@interface UserInfo : NSObject
@property (copy, atomic, readonly) NSString *userid;
@property (copy, atomic, readonly) NSString *mobile;
@property (copy, atomic, readonly) NSString *token;
@property (copy, atomic, readonly) NSString *realname;
@property (copy, atomic, readonly) NSString *idcard;
@property (copy, atomic, readonly) NSString *bankphone;
@property (copy, atomic, readonly) NSString *banName;
@property (copy, atomic, readonly) NSString *banCard;

@property (copy,nonatomic,readonly)NSString *profit;//收益
@property (copy,nonatomic,readonly)NSString *estimateProfit;//预计收益
@property (copy,nonatomic,readonly)NSString *totalAssets;//总资产
@property (copy,nonatomic,readonly)NSString *balance;//账户余额
@property (copy,nonatomic,readonly)NSString *withdrawalsPrice;//提现金额
@property (copy,nonatomic,readonly)NSString *investmentPrice;//在投金额


@property (assign, atomic, readonly) BOOL tradePassword;//设置交易密码
@property (assign, atomic, readonly) BOOL certifierstate;/**< 实名认证 */
@property (assign, atomic, readonly) BOOL bankcardstate;//绑定银行卡
@property (assign ,atomic, readonly) BOOL signState;//是否签到
@property (assign, atomic, readonly) BOOL isinvest;//是否投资

@property (assign,nonatomic,readonly)BOOL ishideMyproperty;//是否隐藏资产yes隐藏


- (instancetype)init;
+ (instancetype)userinfo;

- (void)clear;

- (void)updateLoginInfo:(NSDictionary *)loginInfo;
- (void)updateUserinfo:(NSDictionary *)userinfoDic;

- (void)updateUserPhone:(NSDictionary *)userInfoDic;

- (void)updateUserCertified:(NSDictionary *)dic;

- (void)didCertifiedState:(BOOL)state;
- (void)didSetupTradePasswordState:(BOOL)state;
- (void)didSaveBankcardState:(BOOL)state;
-(void)ddiSaveMypropertyHideState:(BOOL)state;
@end
