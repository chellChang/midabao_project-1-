//
//  returnMoneyModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/9.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface returnMoneyModel : NSObject
@property (copy , nonatomic)NSString *repName;
@property (copy , nonatomic)NSString *repTime;/**<*/
@property (copy , nonatomic)NSString *actualRepTime;/**<实际回款时间*/
@property (assign,nonatomic)CGFloat price;/**<本金金额*/
@property (assign,nonatomic)CGFloat interest;/**<利息金额*/
@property (assign,nonatomic)NSInteger repNumber;/**<回款期数*/
@property (assign,nonatomic)NSInteger paymentStatus;/**<1 回款逾期  2待结算 3七日内到期 4待回款 5 已回款*/
@end
