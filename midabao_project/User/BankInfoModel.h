//
//  BankInfoModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/13.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankInfoModel : NSObject
@property (nonatomic,copy)NSString *bankName;
@property (copy , nonatomic)NSString *bankCard;
@property (copy , nonatomic)NSString *bankImg;
@property (copy , nonatomic)NSString *eachPrice;
@property (copy , nonatomic)NSString *everydayPrice;
@property (copy , nonatomic)NSString *cardId;
@end
