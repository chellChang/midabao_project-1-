//
//  investmentModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface investmentModel : NSObject
@property (copy,nonatomic)NSString *userName;
@property (assign,nonatomic)CGFloat invPrice;
@property (strong,nonatomic)NSDate *invTime;
@property (assign,nonatomic)NSInteger source;/**<1ios 2 android*/
@end
