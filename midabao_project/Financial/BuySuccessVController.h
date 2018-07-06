//
//  BuySuccessVController.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/4.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BaseViewController.h"

@interface BuySuccessVController : BaseViewController
@property (assign,nonatomic)NSInteger showtype;/**<1.显示三个阶段，2.显示四个阶段*/
@property (strong,nonatomic)void(^closeDown)();
@end
