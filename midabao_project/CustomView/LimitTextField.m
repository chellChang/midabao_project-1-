 //
//  ContaintTextField.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/17.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import "LimitTextField.h"

@interface LimitTextField ()

@property (strong, nonnull) RACDisposable *disposable;
@property (nonatomic, strong) UIView *dismissKeyboard;
@property (strong, nonatomic) NSString *lastText;

@property (nonatomic, strong) NSPredicate *filterPredicate;
@end

@implementation LimitTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryView = self.dismissKeyboard;
        _shouldInculdSpace = YES;
        _leftContentMargin = 0;
    }
    
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.inputAccessoryView = self.dismissKeyboard;
    _shouldInculdSpace = YES;
    _leftContentMargin = 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self.disposable dispose];
    
    @weakify(self)
    self.disposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        
        if (notification.object == self) {
            [self textDidChange];
        }
    }];
}

#pragma mark - private method
- (void)dismissKeyboard:(UIButton *) sender {
    
    [self endEditing:YES];
}

#define PREDICATE_KEY @"NAME"
- (BOOL)matchFilterCondition:(NSString *)string {
    
    BOOL matching = [self filterText:string];
    
    NSString *newString = self.shouldInculdSpace ? string : [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL lengthMatch = NO;
    if (self.minLength <= self.maxLength && self.maxLength) {
        
        lengthMatch = self.minLength <= newString.length && newString.length <= self.maxLength;
    } else if (self.minLength) {
        lengthMatch = self.minLength <= newString.length;
    }
    
    return matching & lengthMatch;
}
- (BOOL)canReplacmentText:(NSString *)string {
    
    if ([@"" isEqualToString:string]) {
        return YES;
    } else {
        
        return [self filterText:string] && [self filterLength:self.text];
    }
}
- (BOOL)filterText:(NSString *)string {
    
    if (self.filter) {
        NSString *newString = self.shouldInculdSpace ? string : [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSPredicate *tmpPredicate = [ self.filterPredicate predicateWithSubstitutionVariables:@{PREDICATE_KEY:self.filter} ];
        
        BOOL success = [tmpPredicate evaluateWithObject:newString];
        return success; //filter限制条件
    } else {
        return YES;
    }
}
- (BOOL)filterLength:(NSString *)string {
    
    if (self.minLength <= self.maxLength && self.maxLength) {
        NSString *newString = self.shouldInculdSpace ? string : [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        return newString.length <= self.maxLength;
    } else {
        return YES;
    }
}
- (BOOL)haveSelectedRange {
    
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang hasPrefix:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (selectedRange && position ) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}
#pragma mark - notification

- (void)textDidChange {
    
    //过滤掉不可输入的内容
    //中文高亮
    if ([self haveSelectedRange]) return;
    
    //截取最大长度
    NSInteger offsetLength = self.shouldInculdSpace ? self.maxLength :( self.maxLength + [self.text componentsSeparatedByString:@" "].count - 1);/*(self.maxLength - 1)/4*/;
    if (self.maxLength && self.text.length > offsetLength) {
        self.text = [self.text substringToIndex:offsetLength];
    }
    //其他语言或者中文无高亮
    if ([self canReplacmentText:self.text]) {
        self.lastText = self.text;
    } else if (self.lastText)  {
        self.text = self.lastText;
    } else {
        self.text = nil;
    }
}

#pragma mark - setter & getter
- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    
    [super setKeyboardType:keyboardType];
    
    if (UIKeyboardTypeNumberPad == keyboardType) {
        
    }
    switch (keyboardType) {
        case UIKeyboardTypeNumberPad:
            self.filter = @"[0-9]*";
            break;
        case UIKeyboardTypeDecimalPad:
            self.filter = @"[0-9.]*";
            break;
        default:
            break;
    }
}
- (void)setLeftContentMargin:(NSUInteger)leftContentMargin {
    _leftContentMargin = leftContentMargin;
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (UIView *)dismissKeyboard {
    
    if (!_dismissKeyboard) {
        
        UIView *dismissKeyboard = [[UIView alloc] init];
        
        UIButton *accessoryAction = [[UIButton alloc] init];
        [accessoryAction setImage:[UIImage imageNamed:@"keyboard_dismiss"] forState:UIControlStateNormal];
        [accessoryAction addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [accessoryAction sizeToFit];
        
        [dismissKeyboard addSubview:accessoryAction];
        dismissKeyboard.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(accessoryAction.bounds));
        //添加约束
        accessoryAction.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessoryAction]-(distance)-|" options:0 metrics:@{@"distance":@(20)} views:NSDictionaryOfVariableBindings(accessoryAction)];
        NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[accessoryAction]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accessoryAction)];
        
        [dismissKeyboard addConstraints:hConstraint];
        [dismissKeyboard addConstraints:vConstraint];
        
        _dismissKeyboard = dismissKeyboard;
    }
    return _dismissKeyboard;
}

- (NSPredicate *)filterPredicate {
    
    if (!_filterPredicate) {
        
        _filterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF MATCHES $%@", PREDICATE_KEY]];
    }
    
    return _filterPredicate;
}

- (BOOL)isSuccess {
    
    return [self matchFilterCondition:self.text];
}
@end
