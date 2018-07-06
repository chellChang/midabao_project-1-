//
//  BaseViewController.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DataSourceStateType) {
    DataStateDefault=0,
    DataStateNormal,
    DataStateNetworkError,
    DataStateNoInfo
};
@interface BaseViewController : UIViewController
@property (assign, nonatomic, readwrite) DataSourceStateType stateType;
@property (strong, nonatomic, readwrite) UIImage *noInfoImage;     /**< default is no_info */
@property (strong, nonatomic, readwrite) UIImage *errorNetworkImage; /**< default is err_network */
@property (nonatomic, assign) IBInspectable CGFloat navigationBarAlpha; /**< 不改变bar的alpha */

- (void)chanageNavigationBarAlpha:(CGFloat)navigationBarAlpha;


/**
 *  隐藏以后将 coverView的透明度设为0
 */
- (void)hideNavigationBar;
- (void)showNavigationBar;
@end
