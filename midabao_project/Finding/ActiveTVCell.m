//
//  ActiveTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/10.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ActiveTVCell.h"
#import "UIImageView+LoadImage.h"

@interface ActiveTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *MainImgView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgae;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *activeTime;

@end
@implementation ActiveTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureUi:(findListModel *)model{
    [self.MainImgView loadbnnerImageWithPath:model.images];
    self.titleLab.text=model.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *beginTime = @"";
    NSString *endTime   = @"";
    if (model.actBeginTime!=nil) {
        beginTime=[formatter stringFromDate:model.actBeginTime];
    }
    if (model.actEndTime!=nil) {
        endTime=[formatter stringFromDate:model.actEndTime];
    }
    if (![beginTime isEqualToString:@""]&&![endTime isEqualToString:@""]) {
        self.activeTime.text=[NSString stringWithFormat:@"%@~%@",beginTime,endTime];
    }else{
        self.activeTime.text=@"待确定";
    }
    
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
