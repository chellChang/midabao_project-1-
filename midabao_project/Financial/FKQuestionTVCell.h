//
//  FKQuestionTVCell.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "questModel.h"
@interface FKQuestionTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineX;
-(void)configurUI:(questModel *)model;
@end
