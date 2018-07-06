//
//  SignListTVCell.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralModel.h"
@interface SignListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomLinex;
-(void)configuiWithData:(IntegralModel *)Model;
@end
