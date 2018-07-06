//
//  ProjectDateBottomTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectDateBottomTVCell.h"
@interface ProjectDateBottomTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *middleImg;
@property (weak, nonatomic) IBOutlet UIView *topLinView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end
@implementation ProjectDateBottomTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureWithData:(projectCalendarModel *)model{
    self.middleImg.image=model.paymentStatus==1?[UIImage imageNamed:@"bluePoint"]:[UIImage imageNamed:@"deepbluePoint"];
    self.topLinView.backgroundColor=model.paymentStatus==1?RGB(0xAECAF7):RGB(0x3379EA);
    self.titleLab.textColor=model.paymentStatus==1?RGB(0x999999):RGB(0x333333);
    self.detailLab.textColor=model.paymentStatus==1?RGB(0x999999):RGB(0x333333);
    if (model.paymentStatus==1) {
        if ([[CommonTools dealDate:model.repTime andpreserve:1 andType:1] isEqualToString:@"1970.01.01"]) {
            self.titleLab.text=[NSString stringWithFormat:@"%@：未确定",model.repName];
        }else{
            self.titleLab.text=[NSString stringWithFormat:@"%@：%@",model.repName,[CommonTools dealDate:model.repTime andpreserve:1 andType:1]];
        }
        
    }else{
        if ([[CommonTools dealDate:model.actualRepTime andpreserve:1 andType:1] isEqualToString:@"1970.01.01"]) {
            self.titleLab.text=[NSString stringWithFormat:@"%@：未确定",model.repName];
        }else{
            self.titleLab.text=[NSString stringWithFormat:@"%@：%@",model.repName,[CommonTools dealDate:model.actualRepTime andpreserve:1 andType:1]];
        }
    }
    self.detailLab.text=[NSString stringWithFormat:@"本金：%@ 收益：%@",[CommonTools converFloatForFormatMoney:[CommonTools cutOutCGFloatDecimal:model.price preserve:2]],[CommonTools converFloatForFormatMoney:[CommonTools cutOutCGFloatDecimal:model.interest preserve:2]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
