//
//  UserInfoModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/23.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UserInfoModel.h"
@interface UserInfoModel()
@property (copy,nonatomic,readwrite)NSString *reserveName;
@property (copy,nonatomic,readwrite)NSString *identityard;
@property (copy,nonatomic,readwrite)NSString *isSetBank;/**<是否设置银行卡 0未设置 1已设置*/
@property (copy,nonatomic,readwrite)NSString *isSetPassword;/**<是否设置密码 0未设置 1已设置*/
@property (copy,nonatomic,readwrite)NSString *profit;/**<收益*/
@property (copy,nonatomic,readwrite)NSString *estimateProfit;/**<预计收益*/
@property (copy,nonatomic,readwrite)NSString *couponerCount;
@property (copy,nonatomic,readwrite)NSString *integ;/**<积分*/
@property (copy,nonatomic,readwrite)NSString *repCount;/**<近七日回款数*/
@property (copy,nonatomic,readwrite)NSString *phone;
@property (copy,nonatomic,readwrite)NSString *totalAssets;/**<总资产*/
@property (copy,nonatomic,readwrite)NSString *balance;/**<账户余额*/
@property (copy,nonatomic,readwrite)NSString *withdrawalsPrice;/**<提现金额*/

@property (copy,nonatomic,readwrite)NSString *investmentPrice;/**<再投金额*/
@property (copy,nonatomic,readwrite)NSString *isSign;/**<是否签到０否大于０是*/
@property (copy,nonnull,readwrite) NSString *isInvest;
@end
@implementation UserInfoModel
-(instancetype)initWithDictionary:(NSDictionary *)aDic{
    self=[super init];
    if (self) {
        _reserveName    =[CommonTools convertToStringWithObject:aDic[@"reserveName"]];
        _identityard    =[CommonTools convertToStringWithObject:aDic[@"identityCard"]];
        _isSetBank      =[CommonTools convertToStringWithObject:aDic[@"isSetBank"]];
        _isSetPassword  =[CommonTools convertToStringWithObject:aDic[@"isSetPassword"]];
//        _profit         =[NSString stringWithFormat:@"%.2f",[aDic[@"profit"] floatValue]];
        _profit         =[CommonTools convertFoloatToStringWithObject:aDic[@"profit"]];
        _estimateProfit =[CommonTools convertFoloatToStringWithObject:aDic[@"estimateProfit"]];
        _couponerCount  =[CommonTools convertToStringWithObject:aDic[@"couponerCount"]];
        _integ          =[CommonTools convertToStringWithObject:aDic[@"integ"]];
        _repCount       =[CommonTools convertToStringWithObject:aDic[@"repCount"]];
        _phone          =[CommonTools convertToStringWithObject:aDic[@"phone"]];
        _totalAssets    =[CommonTools convertFoloatToStringWithObject:aDic[@"totalAssets"]];
        _balance        =[CommonTools convertFoloatToStringWithObject:aDic[@"balance"]];
        _withdrawalsPrice =[CommonTools convertFoloatToStringWithObject:aDic[@"withdrawalsPrice"]];
        _investmentPrice =[CommonTools convertFoloatToStringWithObject:aDic[@"investmentPrice"]];
        _isSign         =[CommonTools convertToStringWithObject:aDic[@"isSign"]];
        _isInvest       =[CommonTools convertToStringWithObject:aDic[@"isInvest"]];
    }
    return self;
}

@end
