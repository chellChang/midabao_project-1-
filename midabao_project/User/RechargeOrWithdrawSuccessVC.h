//
//  RechargeOrWithdrawSuccessVC.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/13.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeOrWithdrawSuccessVC : BaseViewController
@property (assign,nonatomic)NSInteger currentType;/**<1.充值2.提现*/
@property (strong,nonatomic)void(^closeDown)();
@end
