//
//  ClickOnceCustomButton.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/20.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 1000  //默认时间间隔
@interface ClickOnceCustomButton : UIButton
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
