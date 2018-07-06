//
//  ContainerScrollView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "HorizontalScrollView.h"

@implementation HorizontalScrollView

- (instancetype)init {
    
    if ( self = [super init] ) {
        
        [self configureContainerScrollView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if ( self = [super initWithCoder:aDecoder]) {
        
        [self configureContainerScrollView];
    }
    return self;
}

- (void)configureContainerScrollView {
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
}

- (void)setContentSubviews:(NSArray *)contentSubviews {
    if (!contentSubviews) return;
    
    @synchronized (self) {
        _contentSubviews = contentSubviews;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [contentSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger inx, BOOL * _Nonnull stop) {
            [self addSubview:obj];
        }];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //NSLog(@"%@ sub ---%@", NSStringFromCGRect(self.bounds), NSStringFromCGRect([self.subviews lastObject].frame));
    
    //if ( !self.window || !self.subviews.count || CGSizeEqualToSize([self.subviews lastObject].frame.size, self.frame.size)) return;
    
    [self.contentSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger inx, BOOL * _Nonnull stop) {
        
        obj.frame = CGRectMake((inx)*self.width, 0, self.width, self.height);
    }];
    self.contentSize = CGSizeMake(self.contentSubviews.count*self.width, self.height);
}

- (__kindof UIView *)presentingSubview {
    
    return self.contentSubviews[[self presentingIndex]];
}

- (NSInteger)presentingIndex {
    
    NSInteger result = 0;
    if ((BOOL)self.width) {
        
        result = self.contentOffset.x/self.width;
    }
    
    return MAX( 0, MIN(result, self.contentSubviews.count));
}

@end
