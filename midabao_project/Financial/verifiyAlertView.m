//
//  verifiyAlertView.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/23.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "verifiyAlertView.h"
@interface verifiyAlertView()
@property (copy,nonatomic)NSString *currentValue;
@end
@implementation verifiyAlertView
-(instancetype)initAlertViewWithframe:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        
    }
    return self;
}

-(void)setBackTefiled:(UITextField *)backTefiled{
    _backTefiled=backTefiled;
    @weakify(self)
    [[_backTefiled rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length==0) {
            self.oneLable.text=@"";
            self.twoLable.text=@"";
            self.threeLab.text=@"";
            self.fourLable.text=@"";
        }else if (x.length==1) {
            self.oneLable.text=[NSString stringWithFormat:@"%ld",[x integerValue]%10];
            self.twoLable.text=@"";
            self.threeLab.text=@"";
            self.fourLable.text=@"";
        }else if (x.length==2){
            self.twoLable.text=[NSString stringWithFormat:@"%ld",[x integerValue]%10];
            self.threeLab.text=@"";
            self.fourLable.text=@"";
        }else if (x.length==3){
            self.threeLab.text=[NSString stringWithFormat:@"%ld",[x integerValue]%10];
            self.fourLable.text=@"";
        }else if (x.length==4){
            self.fourLable.text=[NSString stringWithFormat:@"%ld",[x integerValue]%10];
            NSLog(@"--去提交");
            if ([self.delelgate respondsToSelector:@selector(VerifycodeGoRequestWithCode:)]) {
                [self.delelgate VerifycodeGoRequestWithCode:x];
            }
        }
    }];
}
- (IBAction)closeCurrentView:(UIButton *)sender {
    
    [self hideViewwithanimate:YES];
}
-(void)hideViewwithanimate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.frame=CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
    }else{
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}
- (IBAction)clickVerifyCodel:(UIButton *)sender {
    if ([self.delelgate respondsToSelector:@selector(agaginVerifyCode)]) {
        [self.delelgate agaginVerifyCode];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
