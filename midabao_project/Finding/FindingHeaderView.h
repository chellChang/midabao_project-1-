//
//  FindingHeaderView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/10.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAdvertScrollView.h"
typedef NS_ENUM(NSInteger, findType) {
    complanInfo,
    invitePeople,
    sigineverday,
    safetyguarantee,
    aboutme,
    kfhostline,
    newguider,
    helpcenter,
    seeMsg
};
@protocol FindingHeaderViewDelegate<NSObject>
-(void)clickfindHeadview:(findType)findtype;
@end
@interface FindingHeaderView : UIView

@property(assign,nonatomic)id<FindingHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property (weak, nonatomic) IBOutlet UIButton *safeBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutMeBtn;
@property (weak, nonatomic) IBOutlet UIButton *KFBtn;
@property (weak, nonatomic) IBOutlet UIButton *newguideBtns;
@property (weak, nonatomic) IBOutlet UIButton *helpCenterBtn;

@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet SGAdvertScrollView *labSlider;
-(instancetype)initFindingHeaderViewWithFrame:(CGRect)frame;
@end
