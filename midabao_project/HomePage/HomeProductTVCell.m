//
//  HomeProductTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "HomeProductTVCell.h"
@interface HomeProductTVCell()
@property (weak, nonatomic) IBOutlet UILabel *interestRateLab;
@property (weak, nonatomic) IBOutlet UILabel *addinterestRateLab;
@property (weak, nonatomic) IBOutlet UILabel *limtDay;
@property (weak, nonatomic) IBOutlet UILabel *voteMoney;
@property (weak, nonatomic) IBOutlet UIImageView *yishouqinImg;

@end
@implementation HomeProductTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureUiWithData:(ProjectListModel *)model{
    self.interestRateLab.text=[NSString stringWithFormat:@"%.1f%%",model.interestRate];
    if (model.addInterestRate) {
        self.addinterestRateLab.hidden=NO;
        self.addinterestRateLab.text=[NSString stringWithFormat:@"+%.1f%%",model.addInterestRate];
    }else{
        self.addinterestRateLab.hidden=YES;
    }
    if (model.projectStatus!=5) {
        //已经售罄
        self.yishouqinImg.hidden=NO;
        self.voteMoney.hidden=YES;
        self.interestRateLab.textColor=RGB(0x999999);
        self.addinterestRateLab.textColor=RGB(0x999999);
        self.limtDay.textColor=RGB(0x999999);
        NSString *dayStr=model.termCompany==1?@"天":@"个月";
        NSString *limtdatestr=[NSString stringWithFormat:@"%ld%@",model.term,dayStr];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:limtdatestr];
        [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(limtdatestr.length-dayStr.length,dayStr.length)];
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(0x999999)} range:NSMakeRange(0, limtdatestr.length-dayStr.length)];
        self.limtDay.attributedText=string;
    }else{
        self.voteMoney.hidden=NO;
        self.yishouqinImg.hidden=YES;
        self.interestRateLab.textColor=RGB(0xFF7F1B);
        self.addinterestRateLab.textColor=RGB(0xFF7F1B);
        NSString *daystr=model.termCompany==1?@"天":@"个月";
        NSString *limtDatestr=[NSString stringWithFormat:@"%ld%@",model.term,daystr];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:limtDatestr];
        [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(limtDatestr.length-daystr.length,daystr.length)];
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(0x666666)} range:NSMakeRange(0, limtDatestr.length-daystr.length)];
        self.limtDay.attributedText=string;
        NSString *str=[NSString stringWithFormat:@"%.0f", model.votePrice];
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        formatter.numberStyle=NSNumberFormatterDecimalStyle;
        [formatter setPositiveFormat:@"###,##0"];
        NSString *modifyStr=[NSString stringWithFormat:@"剩余%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:modifyStr];
        [string1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:18]} range:NSMakeRange(2,modifyStr.length-3)];
        [string1 addAttributes:@{NSForegroundColorAttributeName:RGB(0x666666)} range:NSMakeRange(2, modifyStr.length-3)];
        self.voteMoney.attributedText=string1;
    }
//    "SFUIText-Regular",
//    "SFUIText-Semibold"
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
