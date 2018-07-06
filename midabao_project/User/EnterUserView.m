//
//  EnterUserView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "EnterUserView.h"
@interface EnterUserView ()
@property (weak, nonatomic) IBOutlet UIView *EnterView;

@end
@implementation EnterUserView
-(instancetype)initUserViewWithframe:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.EnterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 150);
    }
    return self;
}
-(void)showView{
    [UIView animateWithDuration:0.5 animations:^{
        self.EnterView.frame=CGRectMake(0, self.frame.size.height-150, self.frame.size.width, 150);
    }];
}
-(void)hiddenView{
    [UIView animateWithDuration:0.5 animations:^{
        self.EnterView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 150);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)enterUserAccountClick:(id)sender {
    [self hiddenView];
    !self.EnterUser ? : self.EnterUser();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
