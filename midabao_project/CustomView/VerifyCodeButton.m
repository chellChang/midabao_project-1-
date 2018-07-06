//
//  AuthCodeButton.m
//  wujin-tourist
//
//  Created by wujin  on 15/7/15.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "VerifyCodeButton.h"
#import "TimerIntermediary.h"

#define REPEAT_TIME 1.0f

@interface VerifyCodeButton()

@property (assign, nonatomic) NSInteger         countDownCount;
@property (strong, nonatomic, readonly) NSString          *pristineTitle;
@property (strong, nonatomic) TimerIntermediary *timerIntermediary;
@end

@implementation VerifyCodeButton {
    
    NSString *_pristineTitle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configureAuthCodeButton];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configureAuthCodeButton];
    }
    return self;
}

- (void)configureAuthCodeButton {
        
    self.titleLabel.minimumScaleFactor        = 0.5f;
//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)countDown:(NSInteger)count {
    self.countDownCount = count;
    [self.timerIntermediary start];
}

- (void)setCountDownCount:(NSInteger)countDownCount {
    
    @synchronized (self) {
        _countDownCount = countDownCount;
        
        self.userInteractionEnabled = (_countDownCount <= 0);
        [self setTitle:[self thePresentTitle] forState:UIControlStateNormal];
        [self setTitleColor:RGB(0xcccccc) forState:UIControlStateDisabled];
        if (_countDownCount>0) {
            [self setTitleColor:RGB(0xcccccc) forState:UIControlStateNormal];
        }else{
            [self setTitleColor:RGB(0x3379EA) forState:UIControlStateNormal];
        }
        self.titleLabel.adjustsFontSizeToFitWidth=YES;
    }
}

- (NSString *)thePresentTitle {
    
    if (!_pristineTitle) {
        _pristineTitle = [self titleForState:UIControlStateNormal];
    }
    
    return (_countDownCount <= 0) ? _pristineTitle : [NSString stringWithFormat:@"重新发送(%@s)", @(self.countDownCount)];
}

- (TimerIntermediary *)timerIntermediary {
    
    if (!_timerIntermediary) {
        _timerIntermediary = [TimerIntermediary timerIntermediaryWithTimeInterval:REPEAT_TIME target:self action:^(TimerIntermediary *intermediary, VerifyCodeButton *target) {
            
            target.countDownCount -= REPEAT_TIME;
            if (0 < target.countDownCount) return;
            
            [target.timerIntermediary stop];
        } userInfo:nil repeats:YES];
    }
    
    return _timerIntermediary;
}

@end
