//
//  GesturePassword.h
//  GesturePassword
//
//  Created by Yuanin on 15/10/21.
//  Copyright © 2015年 dengfeng su. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GestureCompletionType) {
    
    kGestureCompletionSuccess = 1,
    kGestureCompletionNotEnough,
    kGestureCompletionUnknown
};

IB_DESIGNABLE
@interface GesturePassword : UIControl

@property (assign, nonatomic, readwrite) IBInspectable CGFloat itemLength;
@property (assign, nonatomic, readwrite) IBInspectable CGFloat lineWidth;
@property (strong, nonatomic, readwrite) IBInspectable UIColor *lineColor;
@property (strong, nonatomic, readwrite) IBInspectable UIColor *unSelectedColor;
@property (strong, nonatomic, readwrite) IBInspectable UIColor *selectedColor;
@property (strong, nonatomic, readwrite) IBInspectable NSString *separatedString; /**<defaiult is @""*/
@property (assign, nonatomic, readwrite) IBInspectable NSUInteger minPasswordLength;//default is 1

@property (strong, nonatomic, readwrite) NSArray<NSString *> *values;//每个按钮代表的值 default is @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]

- (void)clear;

- (void)setCompletionBlock:( void(^)( NSString *, GestureCompletionType) ) completionBlock;
@end
