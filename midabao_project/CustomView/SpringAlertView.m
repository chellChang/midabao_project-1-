//
//  SpringAlertView.m
//  wujin-tourist
//
//  Created by wujin  on 15/7/14.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "SpringAlertView.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGH  [UIScreen mainScreen].bounds.size.height
#define DEFAULT_MARGIN  40
#define DEFAULT_FONT 13
#define ANIMATION_DISTANCE  80

@interface SpringAlertView()

@property (strong, nonatomic, readwrite) NSString *message;
@property (nonatomic, assign) CGSize messageSize;
@property (nonatomic, strong) UIFont *font;
@end

@implementation SpringAlertView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.2 alpha:0.5].CGColor);
    
    CGRect pathRect = CGRectMake(1, 1, CGRectGetWidth(rect) - 2, CGRectGetHeight(rect) - 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:DEFAULT_MARGIN/4];
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    [self.message drawInRect:CGRectMake(DEFAULT_MARGIN/2, DEFAULT_MARGIN/4, self.messageSize.width, self.messageSize.height)
              withAttributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: paragraph}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

+ (void)showMessage:(NSString *)message {
 
    [self showInWindow:[[UIApplication sharedApplication].windows lastObject] message:message];
}
+ (void)showInWindow:(UIWindow *)window message:(NSString *)message {
    
    if (!message.length)
        return;
    
    SpringAlertView *spring = [[SpringAlertView alloc] init];
    
    spring.message = message;
    
    NSDictionary *attributes = @{NSFontAttributeName: spring.font};
    NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 2*DEFAULT_MARGIN, CGFLOAT_MAX);
    
    spring.messageSize = [message boundingRectWithSize:maxSize options:option attributes:attributes context:nil].size;
    spring.frame = CGRectMake((SCREEN_WIDTH - spring.messageSize.width - DEFAULT_MARGIN)/2, SCREEN_HEIGH - 2*spring.messageSize.height,
                              spring.messageSize.width + DEFAULT_MARGIN, spring.messageSize.height + DEFAULT_MARGIN/2);
    
    [window addSubview:spring];
    
    [spring disappearInTheAnimation];
}

- (UIFont *)font {
    
    if (!_font) {
        _font = [UIFont systemFontOfSize:DEFAULT_FONT];
    }
    return _font;
}

#define SPRING_DURATION 0.1
#define SPRING_DISTANCE 5
#define SHOW_DURATION 0.25
#define HIDE_DURATION 0.2
#define STAY_TIME 1.0

- (void)disappearInTheAnimation {
    
    [UIView animateWithDuration:SHOW_DURATION animations:^{
        self.center = CGPointMake(self.center.x, self.center.y - ANIMATION_DISTANCE);
        self.alpha = 1;
    } completion:^(BOOL finished) {
    
        if (finished)
        
            [self downAnimation];
        else [self removeFromSuperview];
    }];
}

- (void)downAnimation {
    
    [UIView animateWithDuration:SPRING_DURATION/2 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + SPRING_DISTANCE);
    } completion:^(BOOL finished) {
        
        if (finished) [self upAnimation];
        else [self removeFromSuperview];
    }];
}

- (void)upAnimation {
    
    [UIView animateWithDuration:SPRING_DURATION/2 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y - SPRING_DISTANCE);
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(STAY_TIME * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self hideAnimation];
            });
        } else  [self removeFromSuperview];
    }];
}
    
- (void)hideAnimation {

    [UIView animateWithDuration:HIDE_DURATION animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + ANIMATION_DISTANCE);
        self.alpha = 0.2f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
