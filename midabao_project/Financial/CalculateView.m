

//
//  CalculateView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "CalculateView.h"
#import "NSString+ExtendMethod.h"
@interface CalculateView ()<UITextFieldDelegate>
@property (nonatomic,copy)NSString *tfvalue;
@property (nonatomic,strong)NSMutableArray *valueArr;
@end
@implementation CalculateView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.textFiled.delegate=self;
    
}
-(instancetype)initCalculateViewWithframe:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.calculateView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 390);
    }
    return self;
}
- (void)showInWindow:(UIWindow *)window {
    
    if (!self.superview) {
        [window addSubview:self];
        self.frame = window.bounds;
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.calculateView.frame=CGRectMake(0, self.frame.size.height-390, self.frame.size.width, 390);
            [self verifySubmitBntWithStats:NO];
            self.huankuanType.text=self.type;
            [self.textFiled becomeFirstResponder];
        }];

    }
}

- (IBAction)closeCalculateView:(id)sender {
    [UIView animateWithDuration:Normal_Animation_Duration animations:^{
        self.calculateView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 390);
    } completion:^(BOOL finished) {
        [self.valueArr removeAllObjects];
        self.textFiled.text=@"";
        self.expectEarningsLab.text=@"0";
        [self removeFromSuperview];
    }];
}
- (IBAction)submitClick:(id)sender {
    self.expectEarningsLab.text=[self.textFiled.text delacalculateDecimalNumberWithString:self.rato];
}
-(void)setOneBtn:(UIButton *)oneBtn{
    _oneBtn=oneBtn;
    @weakify(self)
    [[_oneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:oneBtn.titleLabel.text];
        
    }];
}
-(void)setTwoBtn:(UIButton *)TwoBtn{
    
    _TwoBtn=TwoBtn;
    @weakify(self)
    [[_TwoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:TwoBtn.titleLabel.text];
    }];
}
-(void)setThreeBtn:(UIButton *)ThreeBtn{
    _ThreeBtn=ThreeBtn;
    @weakify(self)
    [[_ThreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:ThreeBtn.titleLabel.text];
    }];
}
-(void)setFourBtn:(UIButton *)FourBtn{
    _FourBtn=FourBtn;
    @weakify(self)
    [[_FourBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:FourBtn.titleLabel.text];
    }];
}
-(void)setFiveBtn:(UIButton *)FiveBtn{
    _FiveBtn=FiveBtn;
    @weakify(self)
    [[_FiveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:FiveBtn.titleLabel.text];
    }];
}
-(void)setSixBtn:(UIButton *)SixBtn{
    _SixBtn=SixBtn;
    @weakify(self)
    [[_SixBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:SixBtn.titleLabel.text];
    }];
}
-(void)setSeaveBtn:(UIButton *)seaveBtn{
    _seaveBtn =seaveBtn;
    @weakify(self)
    [[_seaveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:seaveBtn.titleLabel.text];
    }];
}
-(void)setEightBtn:(UIButton *)eightBtn{
    _eightBtn=eightBtn;
    @weakify(self)
    [[_eightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:eightBtn.titleLabel.text];
    }];
}
-(void)setNineBtn:(UIButton *)nineBtn{
    _nineBtn=nineBtn;
    @weakify(self)
    [[_nineBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:nineBtn.titleLabel.text];
    }];
}
-(void)setZeroBtn:(UIButton *)zeroBtn{
    _zeroBtn=zeroBtn;
    @weakify(self)
    [[_zeroBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:zeroBtn.titleLabel.text];
    }];
}
-(void)setDeleteBtn:(UIButton *)deleteBtn{
    _deleteBtn=deleteBtn;
    @weakify(self)
    [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
        @strongify(self)
        [self updateTextFileWithValue:@"-1"];
        
    }];

}
-(void)updateTextFileWithValue:(NSString *)value{
    if ([value isEqualToString:@"-1"]) {
        if (self.valueArr.count>0) {
            [self.valueArr removeObjectAtIndex:self.valueArr.count-1];
        }
    }else{
        [self.valueArr addObject:value];
    }
    
    NSString *values=@"";
    for (NSString *vl in self.valueArr) {
        if ([values isEqualToString:@""]) {
            values=[NSString stringWithFormat:@"%@",vl];
        }else{
            values=[NSString stringWithFormat:@"%@%@",values,vl];
        }
    }
    [self verifySubmitBntWithStats:[values isEqualToString:@""]?NO:YES];
    self.textFiled.text=values;
}
-(void)verifySubmitBntWithStats:(BOOL)state{
    if (state) {
        self.submitBtn.enabled=YES;
        [self.submitBtn setBackgroundColor:BtnColor];
    }else{
        self.submitBtn.enabled=NO;
        [self.submitBtn setBackgroundColor:BtnUnColor];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoBoardHidden:) name:UIKeyboardWillShowNotification object:nil];
    return YES;
}
- (void)keyBoBoardHidden:(NSNotification *)Notification{
    [self.textFiled resignFirstResponder];
}
-(NSMutableArray *)valueArr{
    if (!_valueArr) {
        _valueArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _valueArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
