//
//  AlertViewBlock.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/9.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clickBlock)(id alertView , NSInteger buttonIndex);

@interface AlertViewManager : NSObject<UIAlertViewDelegate> {
    
    @private
    clickBlock _clickBlock;
}

+ (void)showInViewController:(UIViewController *)vc title:( NSString *)title message:( NSString *)message clickedButtonAtIndex:( clickBlock)clickBlock cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
