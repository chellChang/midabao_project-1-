//
//  ReturnMoneyView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnMoneyView : UIView
+(instancetype)customViewWithState:(NSInteger)state;
@property (assign, nonatomic) BOOL needRefreshList;
@end
