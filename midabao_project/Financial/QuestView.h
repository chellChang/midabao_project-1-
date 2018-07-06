//
//  QuestView.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuestViewDelegate<NSObject>
-(void)questpullUpView;
@end
@interface QuestView : UIView
@property (assign,nonatomic)id<QuestViewDelegate>delegate;
@property (copy,nonatomic)NSString *projectId;
@property (nonatomic,strong)UIScrollView *bankScroll;
-(instancetype)initCustomFrome:(CGRect)frame;
-(void)RefirshUI:(NSString *)projId;
@end
