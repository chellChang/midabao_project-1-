//
//  InsertHeaderView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *myprincipalMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewTopCos;

@property (weak, nonatomic) IBOutlet UILabel *daiearnings;
@property (weak, nonatomic) IBOutlet UILabel *yiearnings;

-(instancetype)initCustomWithFrame:(CGRect)frame;
@end
