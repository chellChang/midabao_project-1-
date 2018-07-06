//
//  userTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/10.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "userTVCell.h"

@implementation userTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = RGBA(0x000000, 0.15);
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        } completion:nil];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
