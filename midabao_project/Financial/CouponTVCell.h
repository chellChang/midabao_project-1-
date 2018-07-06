//
//  CouponTVCell.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "couponrModel.h"

@interface CouponTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backSubView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;
@property (assign,nonatomic)NSInteger type;/**<1.项目优惠券2.我的优惠券*/
@property (nonatomic, copy) void (^usedcoupon)(NSString *couponID);
-(void)configureUIwithD:(couponrModel *)model;
-(void)configuremyallcouponwithdata:(couponrModel *)model;//我的界面的优惠券
@end
