//
//  IdcardTextField.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "IdcardTextField.h"
#define PARTITION_NUM 4
@interface IdcardTextField()
{
    NSInteger _num;
}
@end
@implementation IdcardTextField
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        super.shouldInculdSpace = NO;
        _num=0;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    super.shouldInculdSpace = NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL canReplacement = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    if (canReplacement) {
        NSString *newString  = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([@"" isEqualToString:string]) {//删除
            
            if ( 1 != newString.length && 1 == (newString.length%PARTITION_NUM) ) { //为单数时需要删掉最后的一个空格,如果只有一个字符没有空格
                
                textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(self.text.length - 2, 1) withString:@""];
            }
        } else if ( textField.text.length && (!self.maxLength || newString.length < self.maxLength) ) {  ///判断是否为第一个字符
            ///判断是否有最大长度限制，如果有最大长度的限制，判断是否已经超过最大长度
            if ( !(newString.length % PARTITION_NUM) ) { //当
                textField.text = [textField.text stringByAppendingString:@" "];
            }
        }
    }
    
    return canReplacement;
}
- (void)textDidChange {
    [super textDidChange];
    
    if (self.text.length > _num) {
        if (self.text.length == 4 || self.text.length == 8||self.text.length==13||self.text.length==18) {//输入
            NSMutableString * str = [[NSMutableString alloc ] initWithString:self.text];
            [str insertString:@" " atIndex:(self.text.length-1)];
            self.text = str;
        }
        _num = self.text.length;
        
    }else if (self.text.length < _num){//删除
        if (self.text.length == 4 || self.text.length == 8||self.text.length==13||self.text.length==18) {
            self.text = [NSString stringWithFormat:@"%@",self.text];
            self.text = [self.text substringToIndex:(self.text.length-1)];
        }
        _num = self.text.length;
    }
    
//    NSMutableString *newString  = [[self.text stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
//    NSInteger length = newString.length;
//    NSInteger index = 1;
//    while (length > index*PARTITION_NUM) {
//        [newString insertString:@" " atIndex: index*(PARTITION_NUM + 1) - 1];
//        index++;
//    }
//    
//    self.text = newString;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
