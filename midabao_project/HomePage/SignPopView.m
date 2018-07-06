//
//  SignPopView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "SignPopView.h"
@interface SignPopView()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end
@implementation SignPopView

+ (instancetype)signInSuccessPromptView {
    
    SignPopView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    if ([view isMemberOfClass:[self class]]) {
        view.showView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        view.alpha = 0;
        view.signNumber.transform=CGAffineTransformMakeScale(0.01, 0.01);
        return view;
    } else {
        return nil;
    }
}


- (void)showInWindow:(UIWindow *)window {
    
    if (!self.superview) {
        [window addSubview:self];
        self.frame = window.bounds;
        [UIView animateWithDuration:Normal_Animation_Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1;
            self.showView.transform = CGAffineTransformMakeScale(1, 1);
            self.signNumber.transform=CGAffineTransformMakeScale(1,1);
        } completion:nil];
    }
}
- (IBAction)closeAlertView:(id)sender {
    [UIView animateWithDuration:Normal_Animation_Duration animations:^{
        
        self.showView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.signNumber.transform=CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.superview) {
            [self removeFromSuperview];
        }
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
