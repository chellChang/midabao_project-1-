//
//  ExclusiveButton.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/15.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExclusiveButton : NSObject

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;


@property (strong, nonatomic, readonly) UIButton *invalidButton;
@property (assign, nonatomic) IBInspectable BOOL useEnbleOfInvalid; /**< default is YES */

@property (copy, nonatomic) void(^invalidButtonDidChangeBlock)(UIButton * invalidButton);

- (instancetype)initWithUseEnbleInvalid:(BOOL)useEnble;

- (void)appendButton:(UIButton *)button invalid:(BOOL)invalid;
- (void)setButtonInvalid:(UIButton *)button;
@end
