//
//  WebVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

@interface WebVC : BaseViewController

@property (strong, nonatomic, readonly) UIWebView *webView;
@property (assign, nonatomic) BOOL needPopAnimation;

@property (strong, nonatomic) NSString *webPath;



- (instancetype)initWithWebPath:(NSString *)webPath;
+ (instancetype)webVCWithWebPath:(NSString *)webPath;
@end
