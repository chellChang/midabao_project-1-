//
//  ProjectDateTopTVCell.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDateTopTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyTime;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIImageView *pointImage;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
-(void)createUiwithState:(NSInteger)state andTime:(NSString *)time;
@end
