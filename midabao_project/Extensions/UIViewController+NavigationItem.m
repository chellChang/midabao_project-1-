//
//  UIViewController+NavigationItem.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UIViewController+NavigationItem.h"
#import <objc/runtime.h>

static void *leftActionKey  = "leftActionKey";
static void *rightActionKey = "rightActionKey";

@implementation UIViewController (NavigationItem)

- (void)setLeftAction:(SELBlock)action {
    
    objc_setAssociatedObject(self, leftActionKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (SELBlock)leftAction {
    
    return objc_getAssociatedObject(self, leftActionKey);
}
- (void)setRightAction:(SELBlock)rightAction {
    
    objc_setAssociatedObject(self, rightActionKey, rightAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (SELBlock)rightAction {
    
    return objc_getAssociatedObject(self, rightActionKey);
}

#pragma mark -

- (UIButton *)layoutNavigationLeftButtonWithImage:(UIImage *)image block:(SELBlock)block {
    
    self.leftAction = block;
    return [self layoutNavigationButton:YES image:image action:@selector(performBlock:)];
}

- (UIButton *)layoutNavigationRightButtonWithImage:(UIImage *)image block:(SELBlock)block {
    
    self.rightAction = block;
    
    return [self layoutNavigationButton:NO image:image action:@selector(performBlock:)];
}

- (UIButton *)layoutNavigationRightButtonWithTitle:(NSString *)text color:(UIColor *)color block:(SELBlock)block {
    
    self.rightAction = block;
    
    return [self layoutNavigationButton:NO title:text color:color action:@selector(performBlock:)];
}

- (UIButton *)layoutNavigationButton:(BOOL)left title:(NSString *)text color:(UIColor *)color action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    button.tag = !left;
    button.titleLabel.font = [UIFont systemFontOfSize:Min_Font_Size];
    button.contentHorizontalAlignment = left ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color ? : [UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (left) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    } else {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    
    return button;
}
- (UIButton *)layoutNavigationButton:(BOOL)left image:(UIImage *)image action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    button.tag = !left;
    
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image /*imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]*/ forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:left ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (left) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    } else {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return button;
}

//tag为0  leftButton, tag为1 rightButton
- (void)performBlock:(UIButton *)sender {
    
    SELBlock block = (0 == sender.tag) ? [self.leftAction copy] : [self.rightAction copy];
    
    if (block) {
        
        @weakify(self)
        block(self_weak_);
    }
}

@end
