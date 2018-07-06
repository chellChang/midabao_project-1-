//
//  productInfoView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollView.h"
#import "projectDetailModel.h"
@protocol productInfoDelegate<NSObject>
-(void)pullUpView;
-(void)pullDownView;
@end
@interface productInfoView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCos;
@property (weak, nonatomic) IBOutlet HorizontalScrollView *contentScrollview;
@property(nonatomic,assign)id<productInfoDelegate>delegate;

-(instancetype)initProductInfoViewWithFrame:(CGRect)frame;
-(void)reloadWithModel:(projectDetailModel *)model;
@end
