//
//  FiltrateAlertView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBtn)(UIButton *btn);
@interface FiltrateAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic)selectBtn selectBlock;
-(instancetype)initFiltrateViewWithframe:(CGRect)frame;
- (void)showInWindow:(UIWindow *)window;
@end
