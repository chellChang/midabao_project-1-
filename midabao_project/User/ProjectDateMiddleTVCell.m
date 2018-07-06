//
//  ProjectDateMiddleTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectDateMiddleTVCell.h"
#import "UILabel+Format.h"
@interface ProjectDateMiddleTVCell ()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImg;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *TopTileLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end
@implementation ProjectDateMiddleTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureWithData:(projectCalendarModel *)model{
    self.middleImg.image=model.paymentStatus==1?[UIImage imageNamed:@"bluePoint"]:[UIImage imageNamed:@"deepbluePoint"];
    self.topLineView.backgroundColor=model.paymentStatus==1?RGB(0xAECAF7):RGB(0x3379EA);
    self.bottomLineView.backgroundColor=model.paymentStatus==1?RGB(0xAECAF7):RGB(0x3379EA);
    self.TopTileLab.textColor=model.paymentStatus==1?RGB(0x999999):RGB(0x333333);
    self.detailLab.textColor=model.paymentStatus==1?RGB(0x999999):RGB(0x333333);
    if (model.paymentStatus==1) {
        if ([[CommonTools dealDate:model.repTime andpreserve:1 andType:1] isEqualToString:@"1970.01.01"]) {
            self.TopTileLab.text=[NSString stringWithFormat:@"%@：未确定",model.repName];
        }else{
            self.TopTileLab.text=[NSString stringWithFormat:@"%@：%@",model.repName,[CommonTools dealDate:model.repTime andpreserve:1 andType:1]];
        }
        
    }else{
        if ([[CommonTools dealDate:model.actualRepTime andpreserve:1 andType:1] isEqualToString:@"1970.01.01"]) {
            self.TopTileLab.text=[NSString stringWithFormat:@"%@：未确定",model.repName];
        }else{
            self.TopTileLab.text=[NSString stringWithFormat:@"%@：%@",model.repName,[CommonTools dealDate:model.actualRepTime andpreserve:1 andType:1]];
        }
        
    }
    
    self.detailLab.text=[NSString stringWithFormat:@"本金：%@ 收益：%@",[CommonTools converFloatForFormatMoney:[CommonTools cutOutCGFloatDecimal:model.price preserve:2]],[CommonTools converFloatForFormatMoney:[CommonTools cutOutCGFloatDecimal:model.interest preserve:2]]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
