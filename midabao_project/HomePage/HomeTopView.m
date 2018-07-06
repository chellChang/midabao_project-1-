
//
//  HomeTopView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "HomeTopView.h"
#import "UserInfoManager.h"
@implementation HomeTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
//        UITapGestureRecognizer *ta
        if (UISCREEN_WIDTH==320) {
            self.moneyTopDis.constant=10;
        }
        self.frame=frame;
        [self.AboutMeBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.siginBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.inviteBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        self.myMoneyLab.font=[UIFont fontWithName:@"SFUIText-Medium" size:36];
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
#pragma mark--邀请朋友
- (IBAction)inviteClickBtn:(UIButton *)sender {
    
        if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:invitePeople];
    }
}


#pragma mark --每日签到
- (IBAction)clicksiginBtn:(UIButton *)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:siginTody];
        
    }
}

#pragma  mark --关于我们
- (IBAction)clickaboutMe:(UIButton *)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:aboutMe];
    }
}

#pragma mark --登录注册
- (IBAction)loginOrRegistClick:(id)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:loginOrRegist];
    }
    
}
#pragma mark --安全保障
- (IBAction)securityAssuranceClick:(id)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:securityAssurance];
    }
    
}
#pragma mark --新手指导
- (IBAction)newGuideClick:(id)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        [self.delelgate headerViewClickWithType:newGuide];
    }
    
}
#pragma mark--查看金额
- (IBAction)seeMoneyClick:(id)sender {
    if ([self.delelgate respondsToSelector:@selector(headerViewClickWithType:)]) {
        UIButton *btn=sender;
        btn.selected=!btn.selected;
         [[UserInfoManager shareUserManager].userInfo ddiSaveMypropertyHideState:btn.selected];
        if (btn.selected) {
            self.myMoneyLab.text=@"****";
           
        }else{
            [self.delelgate headerViewClickWithType:seeMoney];
        }
        
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
