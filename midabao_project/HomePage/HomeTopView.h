//
//  HomeTopView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, clickType) {
    loginOrRegist,
    seeMoney,
    securityAssurance,
    newGuide,
    aboutMe,
    siginTody,
    invitePeople
};
@protocol HeadviewDelegate<NSObject>
-(void)headerViewClickWithType:(clickType)type;
@end
@interface HomeTopView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTopDis;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UILabel *AccountTitle;
@property (weak, nonatomic) IBOutlet UIButton *seeAccountBtn;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *guideBtn;
@property (weak, nonatomic) IBOutlet UIButton *AboutMeBtn;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (weak, nonatomic) IBOutlet UIButton *safeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,assign)id<HeadviewDelegate>delelgate;
@end
