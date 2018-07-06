//
//  MyCouponView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MycouponViewDelegate<NSObject>
-(void)seeUsedCouponViewWithState:(NSInteger)state;//查看已使用
-(void)usdCoupoonWithcouponId:(NSString *)couponId andCurrentState:(NSInteger)state;//使用加息券
@end
@interface MyCouponView : UIView
@property(nonatomic,assign)id<MycouponViewDelegate>delegate;
@property (assign, nonatomic) BOOL needRefreshList;
+(instancetype)customViewWithState:(NSInteger)state;

@end
