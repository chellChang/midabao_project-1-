//
//  UINavigationBar+BackgroundColor.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@interface DownLineView : UIView

@property (strong, nonatomic) UIColor *lineColor;
@end

@implementation DownLineView

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, UISCREEN_SCALE);
    
    CGFloat lineY = rect.size.height - UISCREEN_SCALE;
    
    NSInteger realPx = (int)(lineY/UISCREEN_SCALE);
    lineY  = (0 == realPx%2) ? lineY : lineY + UISCREEN_SCALE/2;
        
    CGContextMoveToPoint(ctx, 0, lineY);
    CGContextAddLineToPoint(ctx, rect.size.width, lineY);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}
@end

static void *CoverView  = @"coverView";
static void *ShadowView = @"shadowView";

@implementation UINavigationBar (BarBackgroundColor)

- (void)configureNavigationBar {
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    
    DownLineView *view = [[DownLineView alloc] initWithFrame:CGRectMake(0, -20, self.width, self.height + 20)];
    view.userInteractionEnabled = NO;
    view.clipsToBounds = NO;
    view.backgroundColor=[UIColor whiteColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.subviews[0] insertSubview:self.coverView = view atIndex:0];
    

}

- (void)setCoverView:(UIView *)coverView {
    
    objc_setAssociatedObject(self, CoverView, coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)coverView {
    
    return objc_getAssociatedObject(self, CoverView);
}
- (void)setImageView:(UIImageView *)imageView {
    
    objc_setAssociatedObject(self, ShadowView, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)imageView {
    
    return objc_getAssociatedObject(self, ShadowView);
}

- (void)setCustomBackgroundColor:(UIColor *)color {
    
    self.coverView.backgroundColor = color;
}

- (void)setCustomShadowColor:(UIColor *)color {
    
    [(DownLineView *)self.coverView setLineColor:color];
}

@end
