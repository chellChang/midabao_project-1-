//
//  productDetailView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectDetailModel.h"
/// 滑动响应的方式
/// - pullTypeUp    上翻页
/// - pullTypeDown  下翻页
@class productDetailView;
typedef NS_ENUM(NSInteger, PullType) {
    pullTypeUp=0,
    pullTypeDown
};
@protocol ProductViewDelegate<NSObject>
@optional
-(void)PullDownView:(productDetailView *)simView andPullType:(PullType)type;
@end
@interface productDetailView : UIView<ProductViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *projectRate;
@property (weak, nonatomic) IBOutlet UILabel *extraRate;
@property (weak, nonatomic) IBOutlet UILabel *limtDay;
@property (weak, nonatomic) IBOutlet UILabel *eachAmount;
@property (weak, nonatomic) IBOutlet UILabel *votePrice;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *huankuanType;
@property (weak, nonatomic) IBOutlet UIView *huankuanstapeOne;
@property (weak, nonatomic) IBOutlet UIView *huankuansteapTwo;
@property (strong,nonatomic)void(^refirshCurrentState)();
@property (nonatomic, strong)UILabel *BottomLab;

@property (nonatomic,strong)id<ProductViewDelegate>delegate;
-(void)rockenTimeWithState:(BOOL)state;
-(instancetype)initProductDetailViewWithFrame:(CGRect)frame;
-(void)updataUiWithModel:(projectDetailModel *)model;
@end
