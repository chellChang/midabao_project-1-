//
//  FloatTextField.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "FloatTextField.h"

@implementation FloatTextField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.keyboardType = UIKeyboardTypeDecimalPad;//浮点型键盘
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.keyboardType = UIKeyboardTypeDecimalPad;//浮点型键盘
}

- (void)textDidChange {
    [super textDidChange];
    
    NSRange pointRange = [self.text rangeOfString:@"."]; //允许两位小数点
    
    if (NSNotFound == pointRange.location) return; //没有点
    
    if (0 == pointRange.location) { //点的位置为0， 取消点
        self.text = [self.text substringFromIndex:pointRange.length];
    } else  { //点的位置不为0
        
        //去掉点
        while (1 < [self.text componentsSeparatedByString:@"."].count - 1) { //多个点
            
            self.text = [self.text stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSLiteralSearch range:NSMakeRange(pointRange.location+pointRange.length, self.text.length - pointRange.location - pointRange.length)];
//            NSLog(@"%@", self.text);
        }
        
        //最大长度限制
        NSInteger maxLength = self.maxFloat + pointRange.location + pointRange.length;
        
        if (self.text.length <= maxLength || !self.maxFloat) { //长度正常
            return;
        } else { //超出小数点范围
            self.text = [self.text substringToIndex:maxLength];
        }
    }
}
@end
