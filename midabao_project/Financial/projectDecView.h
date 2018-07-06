//
//  projectDecView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/29.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateTableView.h"
#import "projectDetailModel.h"
@protocol projectDetialDelegate<NSObject>
-(void)pullUpView;
@end
@interface projectDecView : UIView
@property (strong,nonatomic)StateTableView *tableview;
@property (assign,nonatomic)id<projectDetialDelegate>delegate;
@property (nonatomic,strong)UIScrollView *bankScroll;
-(instancetype)initCustomFrome:(CGRect)frame;
-(void)projectReloadWithData:(projectDetailModel *)model andType:(NSInteger)type;
@end
