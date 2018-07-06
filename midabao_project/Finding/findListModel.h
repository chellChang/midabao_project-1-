//
//  findListModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/6.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface findListModel : NSObject
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *type;/**<1头条 2活动*/
@property (copy,nonatomic)NSString *images;
@property (copy,nonatomic)NSString *url;
@property (copy,nonatomic)NSString *beginTime;
@property (copy,nonatomic)NSString *endTimes;
@property (strong,nonatomic)NSDate *actBeginTime;
@property (strong,nonatomic)NSDate *actEndTime;
@property (copy,nonatomic)NSString *runTime;
@property (assign,nonatomic)NSInteger isButton;/**<是否需要button按钮1是0否*/
@end
