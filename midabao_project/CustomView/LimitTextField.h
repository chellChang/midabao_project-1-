//
//  ContaintTextField.h
//  YuanXin_Project
//
//  Created by Sword on 15/9/17.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) IBInspectable NSUInteger minLength; /**< default is 0 */
@property (nonatomic, assign) IBInspectable NSUInteger maxLength; /**< if maxLength < minLength or value is 0 than is limit minLength, this value will limit input*/
@property (nonatomic, assign) IBInspectable BOOL shouldInculdSpace;/**< 长度限制时是否包含空格 */
@property (nonatomic, strong) IBInspectable NSString *filter;
@property (nonatomic, assign) IBInspectable NSUInteger leftContentMargin; /**< default is 0 */
@property (readonly, strong, nonatomic) NSString *lastText;

@property (nonatomic, assign, readonly, getter=isSuccess) BOOL success;

- (void)textDidChange;
@end
