//
//  InteractiveTransition.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InteractiveTransition.h"

@implementation InteractiveTransition

- (void)setViewController:(UIViewController *)viewController {
    
    _viewController = viewController;
    
    //手势监听器
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    pan.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:pan];
}

- (void)edgePan:(UIScreenEdgePanGestureRecognizer *)edgePan {

    CGFloat progress = [edgePan translationInView:self.viewController.view].x/self.viewController.view.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (edgePan.state) {
        case UIGestureRecognizerStateBegan:
            
            self.panInterActiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            
            [self.viewController.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [self.panInterActiveTransition updateInteractiveTransition:progress];
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
            if (progress > 0.5f) {
                [self.panInterActiveTransition finishInteractiveTransition];
            } else {
                [self.panInterActiveTransition cancelInteractiveTransition];
            }
            self.panInterActiveTransition = nil;
            break;
        default:
            break;
    }
    
}
@end
