//
//  InvestmentView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectDetailModel.h"
@protocol InvestmentDelelgte<NSObject>
-(void)investmentPullupView;
@end
@interface InvestmentView : UIView
@property (nonatomic,strong)UIScrollView *bankScroll;
@property (assign,nonatomic)id<InvestmentDelelgte>delegate;
-(instancetype)initCustomFrome:(CGRect)frame;
-(void)RefirshUIModel:(projectDetailModel *)model;
@end
