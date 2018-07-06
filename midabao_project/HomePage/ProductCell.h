//
//  ProductCell.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListModel.h"
@interface ProductCell : UITableViewCell
-(void)configuiWithData:(ProjectListModel *)model;
@end
