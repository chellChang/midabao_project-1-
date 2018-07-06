//
//  GifIndicatorView.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/30.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseIndicatorView.h"

#define GIF_NAME @"loading.gif"
#define IMAGE_NAME @"loading_%@"

#define CORNER_RADIUS 10
#define SHOW_WIDTH    100

static BaseIndicatorView *baseIndicator;

@interface BaseIndicatorView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UILabel     *loading;

@property (strong, nonatomic) UIView *showView;
@property (strong, nonatomic) UIView *backgroundView;

@end


@implementation BaseIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        [self addSubview:self.showView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_backgroundView && !_backgroundView.hidden) {
        _backgroundView.frame = self.bounds;
    }
    
    CGPoint point = [self.window convertPoint:self.window.center toView:self];
    point.x = self.width/2;
    
    self.showView.center = point;
}


+ (void)show {
    [self showInView:[[UIApplication sharedApplication].windows lastObject] maskType:kIndicatorMaskContent];
}
+ (void)showWithMaskType:(IndicatorMaskType)type {
    [self showInView:[[UIApplication sharedApplication].windows lastObject] maskType:kIndicatorMaskContent];
}
+ (void)showInView:(UIView *)view {
    
    [self showInView:view maskType:kIndicatorMaskContent];
}
+ (void)showInView:(UIView *)view maskType:(IndicatorMaskType)maskType {
    
    if (!view) return;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        baseIndicator = [[self alloc] init];
    });
    
    if (baseIndicator.superview) {
        
        [baseIndicator removeFromSuperview];
    }
    [view addSubview:baseIndicator];
    [view bringSubviewToFront:baseIndicator];
    
    [baseIndicator.imageView startAnimating];
    [baseIndicator.loadingView startAnimating];
    
    baseIndicator.backgroundView.hidden = NO;
    if (kIndicatorMaskAll == maskType) {
        baseIndicator.frame = view.bounds;
    } else if (kIndicatorMaskContent == maskType) {
        baseIndicator.frame = CGRectMake(0, [view isMemberOfClass:[UIWindow class]] ? NORMAL_STATUS_AND_NAV_BAR_HEIGHT : 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    } else {
        baseIndicator.backgroundView.hidden = YES;
        baseIndicator.frame = CGRectMake(0, 0,  baseIndicator.showView.width, baseIndicator.showView.height);
        baseIndicator.center = CGPointMake(view.width/2, view.height/2);
    }
    
    [baseIndicator setNeedsLayout];
    [baseIndicator layoutIfNeeded];
}


+ (void)hide {
    
    if (baseIndicator.superview) {
        [baseIndicator.loadingView stopAnimating];
        [baseIndicator removeFromSuperview];
    }
}

- (UILabel *)loading {
    
    if (!_loading) {
        _loading = [[UILabel alloc] init];
        _loading.font = [UIFont systemFontOfSize:Font_Size];
        _loading.textColor = [UIColor whiteColor];
        _loading.text = @"加载中...";
        
        [_loading sizeToFit];
    }
    return _loading;
}
- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        
        @autoreleasepool {
            
            NSMutableArray *mutArr = [NSMutableArray array];
            
            NSInteger i = 0;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:IMAGE_NAME, @(i)]];

            while (image) {
                [mutArr addObject:image];
                
                i++;
                image = [UIImage imageNamed:[NSString stringWithFormat:IMAGE_NAME, @(i)]];
            }
            
            if (mutArr.count) {
                _imageView.image  = mutArr[0];
                _imageView.animationImages = mutArr;
                _imageView.animationDuration = mutArr.count * Normal_Animation_Duration;
                [_imageView sizeToFit];
            }
        }
    }
    
    return _imageView;
}
- (UIActivityIndicatorView *)loadingView {
    
    if (!_loadingView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        view.hidesWhenStopped = YES;
        
        _loadingView = view;
    }
    return _loadingView;
}

- (UIView *)showView {
    
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHOW_WIDTH, SHOW_WIDTH)];
        _showView.backgroundColor = [UIColor clearColor];
        
        CAShapeLayer *showViewLayer = [[CAShapeLayer alloc] init];
        showViewLayer.fillColor = RGBA(0x000000, 0.5).CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRoundedRect(path, NULL, _showView.bounds, CORNER_RADIUS, CORNER_RADIUS);
        showViewLayer.path = path; CGPathRelease(path);
        
        [_showView.layer addSublayer:showViewLayer];
//        [_showView addSubview:self.imageView];
        [_showView addSubview:self.loadingView];
        [_showView addSubview:self.loading];
        
        self.loadingView.center = CGPointMake(SHOW_WIDTH/2, SHOW_WIDTH/2 - Margin_Big_Distance/2);
        self.loading.center = CGPointMake(SHOW_WIDTH/2, SHOW_WIDTH/2 + Margin_Big_Distance + Margin_Small_Distance);
    }
    return _showView;
}
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.alpha = 0.2;
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

@end
