//
//  GestureNavigationController.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "GestureNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "MidabaoTabBar.h"
@interface GestureNavigationController ()<UINavigationBarDelegate>
/**
 *  由于 popViewController 会触发 shouldPopItems，因此用该布尔值记录是否应该正确 popItems
 */
@property (assign , nonatomic) BOOL shouldPopItemAfterPopViewController;
@end

@implementation GestureNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar configureNavigationBar];
    [self.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationBar setCustomShadowColor:[UIColor clearColor]];
    self.gestureEnabled = YES;
    __weak GestureNavigationController *weakNav = self;
    self.shouldPopItemAfterPopViewController = NO;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = weakNav;
    }

    // Do any additional setup after loading the view.
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popViewControllerAnimated:animated];
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToViewController:viewController animated:animated];
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    return [super popToRootViewControllerAnimated:animated];
}
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    //! 如果应该pop，说明是在 popViewController 之后，应该直接 popItems
    if (self.shouldPopItemAfterPopViewController) {
        self.shouldPopItemAfterPopViewController = NO;
        return YES;
    }
    [self popViewControllerAnimated:YES];
    return NO;
    
}
//在push事件的时候设为无效
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - delegate
//在呈现之后设为有效 if the viewController is firstObject, then set enable up false
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        if (1 == self.viewControllers.count)
        self.interactivePopGestureRecognizer.enabled = NO;
        else
        self.interactivePopGestureRecognizer.enabled = self.gestureEnabled;
    }
}

#pragma mark - iOS 9上面代码有效地切换 self.interactivePopGestureRecognizer.enabled。 but iOS9 以下有问题
//iOS 9 以下加入下面的代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.gestureEnabled;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
