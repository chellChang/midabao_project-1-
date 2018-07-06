//
//  verifiyAlertView.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/23.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyCodeButton.h"
@protocol verifyDelegate<NSObject>
-(void)VerifycodeGoRequestWithCode:(NSString *)code;
-(void)agaginVerifyCode;
@end
@interface verifiyAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *oneLable;
@property (weak, nonatomic) IBOutlet UILabel *twoLable;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *fourLable;
@property (weak, nonatomic) IBOutlet UITextField *backTefiled;
@property (assign,nonatomic)id <verifyDelegate>delelgate;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *getverifyCode;
-(instancetype)initAlertViewWithframe:(CGRect)frame;
-(void)hideViewwithanimate:(BOOL)animate;
@end
