//
//  InteractiveTransition.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveTransition : NSObject

@property (weak, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *panInterActiveTransition;

@end
