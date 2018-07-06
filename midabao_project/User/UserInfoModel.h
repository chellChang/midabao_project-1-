//
//  UserInfoModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/23.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (copy,nonatomic,readonly)NSString *reserveName;
@property (copy,nonatomic,readonly)NSString *identityard;
@property (copy,nonatomic,readonly)NSString *isSetBank;/**<是否设置银行卡 0未设置 1已设置*/
@property (copy,nonatomic,readonly)NSString *isSetPassword;/**<是否设置密码 0未设置 1已设置*/
@property (copy,nonatomic,readonly)NSString *profit;/**<收益*/
@property (copy,nonatomic,readonly)NSString *estimateProfit;/**<预计收益*/
@property (copy,nonatomic,readonly)NSString *couponerCount;
@property (copy,nonatomic,readonly)NSString *integ;/**<积分*/
@property (copy,nonatomic,readonly)NSString *repCount;/**<近七日回款数*/
@property (copy,nonatomic,readonly)NSString *phone;
@property (copy,nonatomic,readonly)NSString *totalAssets;/**<总资产*/
@property (copy,nonatomic,readonly)NSString *balance;/**<账户余额*/
@property (copy,nonatomic,readonly)NSString *withdrawalsPrice;/**<提现金额*/

@property (copy,nonatomic,readonly)NSString *investmentPrice;/**<再投金额*/
@property (copy,nonatomic,readonly)NSString *isSign;/**<是否签到０否大于０是*/
@property (copy,nonnull,readonly) NSString *isInvest;/**<是否签到０否大于０是*/


-(instancetype _Nullable )initWithDictionary:(NSDictionary *_Nullable)aDic;
@end
