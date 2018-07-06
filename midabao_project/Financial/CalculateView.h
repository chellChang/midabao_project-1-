//
//  CalculateView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculateView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIView *calculateView;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *FourBtn;
@property (weak, nonatomic) IBOutlet UIButton *FiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *SixBtn;
@property (weak, nonatomic) IBOutlet UIButton *seaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UIButton *nineBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *huankuanType;
@property (weak, nonatomic) IBOutlet UILabel *expectEarningsLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic,copy)NSString *rato;
@property (nonatomic,copy)NSString *type;
-(instancetype)initCalculateViewWithframe:(CGRect)frame;
- (void)showInWindow:(UIWindow *)window;
@end
