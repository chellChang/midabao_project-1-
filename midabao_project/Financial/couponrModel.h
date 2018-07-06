//
//  couponrModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface couponrModel : NSObject
@property (nonatomic,assign)CGFloat couponPrice;
@property (copy,nonatomic)NSString *proName;
@property (assign,nonatomic)NSInteger day;
@property (strong,nonatomic)NSDate *effecTime;
@property (copy,nonatomic)NSString *couponName;
@property (assign,nonatomic)NSInteger useStatus;/**<1未使用 0已使用 2已过期*/
@property (assign,nonatomic)NSInteger investPriceUp;
@property (assign,nonatomic)NSInteger couponType;/**<优惠券类型 1加息券 2满减券 3体验金*/
@property (assign,nonatomic)NSInteger isAva;/**<项目里的红包使用:1可用 0不可用 */
@property (copy,nonatomic)NSString *couponrId;
@property (assign,nonatomic)BOOL isselected;
@end
