//
//  FindingHeaderView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/10.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FindingHeaderView.h"

@implementation FindingHeaderView
-(instancetype)initFindingHeaderViewWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        [self.companyBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.inviteBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.siginBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.safeBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.aboutMeBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.KFBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.newguideBtns addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.helpCenterBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
    
}
//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = RGBA(0x000000, 0.15);
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.backgroundColor = [UIColor clearColor];
    } completion:nil];
}
- (IBAction)complanInfoClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:complanInfo];
    }
}
- (IBAction)inviteClick:(UIButton *)sender {
  
    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:invitePeople];
    }
}

- (IBAction)siginClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:sigineverday];
    }
}
- (IBAction)safeClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:safetyguarantee];
    }
}

- (IBAction)AboutMeClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:aboutme];
    }
}

- (IBAction)kfhostlineClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:kfhostline];
    }
}
- (IBAction)newGuideClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:newguider];
    }
}

- (IBAction)helpCenterClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:helpcenter];
    }
}
- (IBAction)sendMessageClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickfindHeadview:)]) {
        [self.delegate clickfindHeadview:seeMsg];
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
