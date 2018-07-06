//
//  projectCalendarModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface projectCalendarModel : NSObject
@property(copy,nonatomic)NSString *repTime;//预计回款时间
@property (copy,nonatomic)NSString *actualRepTime;//实际回款时间
@property (assign,nonatomic)CGFloat paymentPrice;//应还金额
@property (assign,nonatomic)CGFloat price;/**<本金金额*/
@property (assign,nonatomic)CGFloat interest;/**<利息金额*/
@property (assign,nonatomic)NSInteger repNumber;/**<回款期数*/
@property (copy,nonatomic)NSString *repName;//回款名称
@property (assign,nonatomic)NSInteger paymentStatus;/**<回款状态  1待回款 2已回款 */
@property (assign,nonatomic)NSInteger transStatus;/**<交易状态 1 处理中2 交易成功 3交易失败'*/
@end
