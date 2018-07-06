//
//  capitalDetailModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface capitalDetailModel : NSObject
@property (copy , nonatomic)NSString *endTme;
@property (copy , nonatomic)NSString *created;//yy.MM
@property (copy , nonatomic)NSString *transExplain;
@property (copy , nonatomic)NSString *estiTime;
@property (assign,nonatomic)CGFloat price;
@property (assign,nonatomic)NSInteger capitaloperator;/**<运算 类型 1 加 2减*/
@property (assign,nonatomic)NSInteger transStatus;
@property (assign,nonatomic)NSInteger type;
@property (copy , nonatomic)NSString *crateTime;//yy.MM.dd
@property (copy , nonatomic)NSString *crateTimeDetail;//yy.MM.dd hh.mm
@property (copy , nonatomic)NSString *endTimeDetail;//yy.MM.dd hh.mm
@property (copy , nonatomic)NSString *transNumber;//交易号
@end
