//
//  FirstEnterLinQi.m
//  wujin-buyer
//
//  Created by wujin  on 15/2/6.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "AiMiGuidePage.h"
#import "TCKeychain.h"
#import "UserinfoManager.h"
#import "CostomPageCol.h"
@interface AiMiGuidePage() <UIScrollViewDelegate>

@property (strong, nonatomic, readwrite) UIPageControl *pageControl;
@property (strong, nonatomic, readwrite) UIScrollView *scroll;
@property (strong, nonatomic, readwrite) UIButton *enter;
@property (strong, nonatomic, readwrite) NSMutableArray *images;

@property (copy, nonatomic, readwrite) void(^completionBlock)();

@end

@implementation AiMiGuidePage

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.pageControl.translatesAutoresizingMaskIntoConstraints) {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hPageControlConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pageControl]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)];
        NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-(distance)-|" options:0 metrics:@{@"distance":@(Margin_Small_Distance)} views:NSDictionaryOfVariableBindings(_pageControl)];
        
        [self addConstraints:hPageControlConstraint];
        [self addConstraints:vConstraint];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.scroll.frame.size, self.frame.size)) {
        
        self.scroll.frame = self.bounds;
        for (UIImageView *imageView in self.images) {
            imageView.frame = CGRectMake( imageView.tag*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) );
            
            if (self.images.count - 1 == imageView.tag) {
                CGPoint center = imageView.center;
                center.y = CGRectGetHeight(imageView.frame) - Margin_Big_Distance - Margin_Small_Distance - CGRectGetHeight(self.pageControl.bounds)-30;
                self.enter.frame=CGRectMake(center.x-93, center.y-30, 186, 74);
            }
        }
    }
}

#pragma mark -  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scroll) {
        self.pageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    }
}

+ (instancetype)AiMiGuidePageWithImages:(NSArray<UIImage *> *)images buttonImage:(UIImage *)buttonImage completion:(void (^)()) completionBlock {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    AiMiGuidePage *_first = [[AiMiGuidePage alloc] initWithFrame:frame];
    _first.completionBlock = completionBlock;
    
    _first.scroll.contentSize = CGSizeMake( images.count*width, height);
    _first.pageControl.numberOfPages = images.count;
    [_first.pageControl sizeToFit];
    [_first.enter setImage:buttonImage forState:UIControlStateNormal];
//    [_first.enter sizeToFit];
    
    for (NSInteger i = 0; i < images.count; ++i) {
    
        UIImage *img = images[i];
        UIImageView *image = [[UIImageView alloc] initWithImage:img];
        image.tag = i;//CGRectMake( i*CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame) );
        
        [_first.images addObject:image];
        [_first.scroll addSubview:image];
        
        [_first.scroll sendSubviewToBack:image];
    }
    
    return _first;
}

+ (BOOL)canShow {
    
    return ([[NSUserDefaults standardUserDefaults] boolForKey:Need_Guide_Page]);
}

+ (void)showWithComplete:( void(^)() ) complete {
    
     [self showInView: [[UIApplication sharedApplication].windows lastObject] complete:complete];
}
+ (void)showInView:(UIView *)view complete:( void(^)() ) complete {
    
    NSMutableArray *tmpImages = [[NSMutableArray alloc] init];
    
    NSInteger i = 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_page_%li", (long)i]];
    while (image) {
        [tmpImages addObject:image];
        
        i++;
        image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_page_%li", (long)i]];
    }
    
    if ( 0 == tmpImages.count)
        return;
    
    AiMiGuidePage *guidePage = [AiMiGuidePage AiMiGuidePageWithImages:tmpImages buttonImage:[UIImage imageNamed:@"guide_page_button"]   completion:complete];
    [guidePage updateConstraintsIfNeeded];
    
    [view addSubview:guidePage];
}

- (void)cancel:(UIButton *)sender {
    
    [UIView animateWithDuration:1.f animations:^{
        
        self.scroll.transform = CGAffineTransformMakeScale(2, 2);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:Need_Guide_Page];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self removeFromSuperview];
        if (self.completionBlock) {
            self.completionBlock();
        }
    }];
}
- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setValue:[UIImage imageNamed:@"guide_pointUn"] forKeyPath:@"_pageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"guide_pint"] forKeyPath:@"_currentPageImage"];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
- (UIButton *)enter {
    
    if (!_enter) {
        _enter = [[UIButton alloc] init];
        [self.scroll addSubview:_enter];
        
        [_enter addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enter;
}
- (UIScrollView *)scroll {
    
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init /*WithFrame:[UIScreen mainScreen].bounds*/];
        [self addSubview:_scroll];
        
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
        _scroll.bounces = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
    }
    return _scroll;
}
- (NSMutableArray *)images {
    
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}
@end
