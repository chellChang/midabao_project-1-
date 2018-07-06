//
//  AlertViewBlock.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/9.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AlertViewManager.h"

@interface AlertViewManager()

@property (strong, nonatomic) AlertViewManager *alterDelegate;//仅当ios-8以下才需要
@end

@implementation AlertViewManager

+ (void)showInViewController:(UIViewController *)vc title:( NSString *)title message:( NSString *)message clickedButtonAtIndex:( clickBlock ) clickBlock cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSMutableArray *otherTitles = [[NSMutableArray alloc] init];
    
    va_list argc;
    va_start(argc, otherButtonTitles);
    
    NSString *otherString = otherButtonTitles;
    
    while ( otherString ) {
        [otherTitles addObject:otherString];
        otherString = va_arg(argc, NSString *);
    }
    va_end(argc);
    
    if (SYSTEM_VERSION_GREATER_THAN_8) {
        [self showInViewController:vc title:title message:message clickedButtonAtIndex:clickBlock cnacelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
    } else {
        [self showAlertViewWithTitle:title message:message clickedButtonAtIndex:clickBlock cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
    }
}

//iOS8 +
+ (void)showInViewController:(UIViewController *)vc
                       title:( NSString *)title
                     message:(NSString *)message
        clickedButtonAtIndex:(clickBlock)clickBlock
           cnacelButtonTitle:(NSString *) cancelButtonTitle
           otherButtonTitles:(NSArray *)otherTitles {
    
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (clickBlock) clickBlock(alertControler, 0);
    }];
    [alertControler addAction:cancelAction];
    
    //其他按钮
    for (NSString *otherTitle in otherTitles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            !clickBlock ? : clickBlock(alertControler, [otherTitles indexOfObject:otherTitle] + 1); //cancel button is 0;
        }];
        [alertControler addAction:action];
    }
    
    [vc presentViewController:alertControler animated:YES completion:nil];
}

//iOS7
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
          clickedButtonAtIndex:(clickBlock)clickBlock
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherTitles {
    
    AlertViewManager *alterManager = [[AlertViewManager alloc] init];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:alterManager cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    alterManager->_clickBlock = [clickBlock copy];
    for (NSString *otherTitle in otherTitles) {
        [alertView addButtonWithTitle:otherTitle];
    }
    [alertView show];
    
    alterManager.alterDelegate = alterManager;// circular reference
}

#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    !self->_clickBlock ? : self->_clickBlock( alertView, buttonIndex);
    
    self.alterDelegate = nil;//一定要解除掉循环引用
}

@end
