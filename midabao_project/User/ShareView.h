//
//  ShareView.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^shareBtn)(BOOL isshare);
@interface ShareView : UIView
@property (strong,nonatomic)shareBtn selectShareBlock;
+(instancetype)sharedWechatViewWithURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbImagePath:(NSString *)thumbImagePath;
- (void)showInWindow:(UIWindow *)window;
-(BOOL)canShared;
@end
