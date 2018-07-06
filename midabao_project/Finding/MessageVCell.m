//
//  MessageVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MessageVCell.h"

@implementation MessageVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainView.layer.cornerRadius=4;
    self.mainView.layer.masksToBounds=YES;
    // Initialization code
}
-(void)configureUi:(findListModel *)model{
    self.messageTitle.text=model.title;
    self.timeLab.text=model.beginTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
