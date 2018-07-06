//
//  TransitionAnimation.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "TransitionAnimation.h"
#import "UINavigationBar+BackgroundColor.h"

#import "BaseViewController.h"

@interface TransitionAnimation()

@property (assign, nonatomic) UINavigationControllerOperation operation;
@end

@implementation TransitionAnimation

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    
    self = [super init];
    if (self) {
        
        if (UINavigationControllerOperationPop == operation || UINavigationControllerOperationPush == operation) {
            _operation = operation;
        } else {
            return nil;
        }
    }
    
    return self;
}
+ (instancetype)transitionAnimation:(UINavigationControllerOperation)operation {
    
    return [[TransitionAnimation alloc] initWithOperation:operation];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return Normal_Animation_Duration;
}

- (void)animateTransition:( id<UIViewControllerContextTransitioning> ) transitionContext {
    
    switch (self.operation) {
        case UINavigationControllerOperationPush:
            [self pushAnimation:transitionContext];
            break;
            
        case UINavigationControllerOperationPop:
            [self popAnimtaion:transitionContext];
            break;
        default:
            break;
    }
}

- (void)pushAnimation:( id<UIViewControllerContextTransitioning> ) transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toVC.view];

    
    CGRect nextToFrame = fromVC.view.frame;
    
    CGRect currentToFrame = nextToFrame;
    currentToFrame.origin.x = -currentToFrame.size.width/4;
    
    CGRect nextStartFrame = nextToFrame;
    nextStartFrame.origin.x = transitionContext.containerView.width;
    toVC.view.frame = nextStartFrame;

    fromVC.navigationController.navigationBar.coverView.alpha = [fromVC isKindOfClass:[BaseViewController class]] ? ((BaseViewController *)fromVC).navigationBarAlpha : 1;
    UINavigationBar *navigationBar = fromVC.navigationController.navigationBar;
    
    for (NSLayoutConstraint *constraint in toVC.view.constraints) {
        if (constraint.firstItem == toVC.topLayoutGuide
            && constraint.firstAttribute == NSLayoutAttributeHeight
            && constraint.secondItem == nil
            && constraint.constant < navigationBar.height) {
            
            constraint.constant += navigationBar.height;
        }
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        fromVC.view.frame = currentToFrame;
        toVC.view.frame = nextToFrame;
        navigationBar.coverView.alpha = [toVC isKindOfClass:[BaseViewController class]] ? ((BaseViewController *)toVC).navigationBarAlpha : 1;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimtaion:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient_alpha_black"]];
     shadowImageView.alpha = 0.3;
    if (toVC.tabBarController.tabBar.hidden) {
        [fromVC.view addSubview:shadowImageView];
        shadowImageView.frame = CGRectMake(-shadowImageView.width, 0, shadowImageView.width, UISCREEN_HEIGHT);
    } else {
        [toVC.tabBarController.tabBar addSubview:shadowImageView];
        shadowImageView.frame = CGRectMake(UISCREEN_WIDTH - shadowImageView.width,
                                           -UISCREEN_HEIGHT + TABBAR_HEIGHT + (([toVC isKindOfClass:[BaseViewController class]] ? ((BaseViewController *)toVC).navigationBarAlpha : 1) ? STATUS_AND_NAV_BAR_HEIGHT : 0),
                                           shadowImageView.width,
                                           UISCREEN_HEIGHT);
    }
    
    
    CGRect nextEndFrame = fromVC.view.frame;
    CGRect fromEndFrame   = fromVC.view.frame;
    fromEndFrame.origin.x = transitionContext.containerView.width;
    
    CGRect nextStartFrame = nextEndFrame;
    nextStartFrame.origin.x = -nextStartFrame.size.width/4;
    toVC.view.frame = nextStartFrame;

    fromVC.navigationController.navigationBar.coverView.alpha = [fromVC isKindOfClass:[BaseViewController class]] ? ((BaseViewController *)fromVC).navigationBarAlpha : 1;
    UINavigationBar *navigationBar = toVC.navigationController.navigationBar;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        fromVC.view.frame = fromEndFrame;
        navigationBar.coverView.alpha = [toVC isKindOfClass:[BaseViewController class]] ? ((BaseViewController *)toVC).navigationBarAlpha : 1;
        toVC.view.frame = nextEndFrame;
        shadowImageView.alpha = 0.1f;
    } completion:^(BOOL finished) {
        
        [shadowImageView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
