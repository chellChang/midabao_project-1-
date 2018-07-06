//
//  WebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "WebVC.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UINavigationBar+BackgroundColor.h"
@interface WebVC () <UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (strong, nonatomic, readwrite) UIWebView *webView;

@end

@implementation WebVC

#pragma mark - Lift Cycle

- (instancetype)initWithWebPath:(NSString *)webPath {
    
    if (self = [super init]) {
        //_webPath = [webPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _webPath = webPath;
        NSLog(@"%@",_webPath);
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
+ (instancetype)webVCWithWebPath:(NSString *)webPath {
    
    return [[[self class] alloc] initWithWebPath:webPath];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationController.navigationBar addSubview:_progressView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavifationLeftButton];
    [self.view addSubview:self.webView];
    [self.view setNeedsUpdateConstraints];
    
    [self loadWeb];
}

- (void)configureNavifationLeftButton {
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(WebVC *viewController) {
        [self cleanCacheAndCookie];
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_progressView removeFromSuperview];
    [self.webView stopLoading];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.webView.translatesAutoresizingMaskIntoConstraints) {
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView}];
        NSArray *vCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView, @"topLayoutGuide":self.topLayoutGuide}];
        
        [self.view addConstraints:hCon];
        [self.view addConstraints:vCon];
    }
}

- (void)loadWeb {
    
    [self.webView stopLoading];
//    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *ReplacePath=[self.webPath stringByReplacingOccurrencesOfString:@"#" withString:@"YXinglicai"];
        NSString *CodePath=[[NSString stringWithFormat:@"%@",ReplacePath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *ReplaceStr=[CodePath stringByReplacingOccurrencesOfString:@"YXinglicai" withString:@"#"];
        dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ReplaceStr]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];//NSURLRequestReloadIgnoringLocalCacheData加载时清除缓存
        });
        
        
    });
}

- (void)setWebPath:(NSString *)webPath {
    _webPath = webPath;

    if (self.view.window) {
        [self loadWeb];
    }
}

- (UIWebView *)webView {
    
    if (!_webView) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        UIWebView *web = [[UIWebView alloc] init];
        web.delegate = _progressProxy;
        web.scrollView.showsVerticalScrollIndicator = NO;
        web.scrollView.backgroundColor = BackgroundColor;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        CGFloat progressBarHeight = 3.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressColor=RGB(0x3379EA);
        _webView = web;
    }
    return _webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    解决UIWebView加载js时内存泄露的方法是在webViewDidFinishLoad方法中设置如下：原文地址是：http://blog.techno-barje.fr//post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
//    [BaseIndicatorView hide];
    
//    NSString *body = @"document.getElementsByTagName('body')[0].style.background='#F5F5F9'";
//    [webView stringByEvaluatingJavaScriptFromString:body];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
//    [BaseIndicatorView hide];
}

@end
