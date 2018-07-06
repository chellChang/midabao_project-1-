//
//  ContainerScrollView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalContentViewRefresh <NSObject>

- (void)beginRefresh;
- (void)stopRefreshing;

@end

@interface HorizontalScrollView : UIScrollView

@property(nonatomic, readwrite, copy) NSArray<__kindof UIView<HorizontalContentViewRefresh> *> *contentSubviews;

- (__kindof UIView<HorizontalContentViewRefresh> *)presentingSubview;
- (NSInteger)presentingIndex;
@end
