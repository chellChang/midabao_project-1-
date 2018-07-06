//
//  InsertHeaderView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InsertHeaderView.h"

@implementation InsertHeaderView
-(instancetype)initCustomWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.myprincipalMoney.font=[UIFont fontWithName:@"SFUIText-Medium" size:24];
        self.daiearnings.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];
        self.yiearnings.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
