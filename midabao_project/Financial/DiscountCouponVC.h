//
//  DiscountCouponVC.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BaseViewController.h"
#import "couponrModel.h"
@interface DiscountCouponVC : BaseViewController
@property (nonatomic,copy)NSString *projectId;
@property (nonatomic,assign)NSInteger currentMoney;
@property (assign,nonatomic)NSInteger cancouponnum;
@property (copy , nonatomic)NSString *couponIds;
@property (strong,nonatomic)void(^usedCoupon)(NSString *str,couponrModel *model);
@end
