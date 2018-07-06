//
//  BaseViewController.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BaseViewController.h"
#import "GestureNavigationController.h"
#import "MessageForwarder.h"
#import "InteractiveTransition.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TransitionAnimation.h" 
@interface BaseViewController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) MessageForwarder *forwarder;
@property (strong, nonatomic) InteractiveTransition *interactiveTransition;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationBarAlpha = 1.0f;
    self.interactiveTransition.viewController = self;
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"lineX_d8"]];
    [self.navigationController.navigationBar setCustomShadowColor:RGB(0xd8d8d8)];
    if ([self.navigationController isKindOfClass:[GestureNavigationController class]]) {
        ((GestureNavigationController *)self.navigationController).gestureEnabled = NO;//应对iOS7.0可能被系统自带手势覆盖问题
    }
    self.view.backgroundColor=BackgroundColor;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (self.navigationController) {
        self.forwarder.delegateTargets = @[self.navigationController, self];
        self.navigationController.delegate = (id<UINavigationControllerDelegate>)self.forwarder;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = (id<UINavigationControllerDelegate>)self.navigationController;
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}
#pragma mark - Public Method
- (void)hideNavigationBar {
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.coverView.alpha = 0;
}
- (void)showNavigationBar {
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)chanageNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    if (navigationBarAlpha>0) {
        self.navigationController.navigationBarHidden = NO;
    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    
    self.navigationBarAlpha = navigationBarAlpha;
    self.navigationController.navigationBar.coverView.alpha = navigationBarAlpha;
}

#pragma mark - NavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
    TransitionAnimation *animation = [[TransitionAnimation alloc] initWithOperation:operation];
    
    
    return animation;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(TransitionAnimation *)animationController {
    
    return self.interactiveTransition.panInterActiveTransition;
}


#pragma mark - Getter
- (MessageForwarder *)forwarder {
    
    if (!_forwarder) {
        _forwarder = [[MessageForwarder alloc] init];
    }
    return _forwarder;
}
- (InteractiveTransition *)interactiveTransition {
    
    if (!_interactiveTransition) {
        _interactiveTransition = [[InteractiveTransition alloc] init];
    }
    return _interactiveTransition;
}
-(void)setStateType:(DataSourceStateType)stateType{
    _stateType=stateType;
    switch (_stateType) {
            case DataStateDefault:
            
            break;
            case DataStateNormal:
            
            break;
            case DataStateNoInfo:
            
            break;
            case DataStateNetworkError:
            
            break;
        default:
            break;
    }
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
