//
//  FiltrateAlertView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FiltrateAlertView.h"
@interface FiltrateAlertView()

@end
@implementation FiltrateAlertView
-(instancetype)initFiltrateViewWithframe:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.contentView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 195);
    }
    return self;
}

- (void)showInWindow:(UIWindow *)window {
    
    if (!self.superview) {
        [window addSubview:self];
        self.frame = window.bounds;
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.contentView.frame=CGRectMake(0, self.frame.size.height-195, self.frame.size.width, 195);
        }];
        
    }
}
- (IBAction)clickchooseType:(id)sender {
    UIButton *btn=(UIButton *)sender;
    for (int i=0; i<6; i++) {
        UIButton *subBtn=[btn.superview viewWithTag:500+i];
        if (subBtn.tag!=btn.tag) {
            subBtn.selected=NO;
        }else{
            subBtn.selected=YES;
        }
    }
    !self.selectBlock?:self.selectBlock(btn);
    [self closeView:nil];
}


- (IBAction)closeView:(id)sender {
    [UIView animateWithDuration:Normal_Animation_Duration animations:^{
        self.contentView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 195);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
