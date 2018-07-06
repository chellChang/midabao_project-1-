//
//  EnterUserView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterUserView : UIView
@property (copy, nonatomic) void(^EnterUser)();
-(instancetype)initUserViewWithframe:(CGRect)frame;
-(void)showView;
-(void)hiddenView;
@end
