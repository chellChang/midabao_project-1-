//
//  SignPopView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignPopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *signAlertImg;
@property (weak, nonatomic) IBOutlet UILabel *signNumber;
- (void)showInWindow:(UIWindow *)window;
+(instancetype)signInSuccessPromptView;
@end
