
//
//  ReturnMoneyTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ReturnMoneyTVCell.h"
@interface ReturnMoneyTVCell()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *myMoney;
@property (weak, nonatomic) IBOutlet UILabel *shouyiLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLabl;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@end
@implementation ReturnMoneyTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)configureUI:(returnMoneyModel *)model{
    self.proName.text=model.repName;
    NSString *str=[NSString stringWithFormat:@"%lf", [CommonTools cutOutCGFloatDecimal:model.price preserve:2]];
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"###,##0.00"];
    self.myMoney.text=[NSString stringWithFormat:@"本金：%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
    NSString *shouyiStr=[NSString stringWithFormat:@"%lf",[CommonTools cutOutCGFloatDecimal:model.interest preserve:2]];
    self.shouyiLab.text=[NSString stringWithFormat:@"收益：%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[shouyiStr doubleValue]]]];
    if (model.paymentStatus==5) {
        if ([model.actualRepTime isEqualToString:@""]) {
            self.detailLabl.text=@"回款时间：--";
        }else{
            self.detailLabl.text=[NSString stringWithFormat:@"回款时间%@",model.actualRepTime];
        }
    }else{
        if ([model.repTime isEqualToString:@""]) {
            self.detailLabl.text=@"预计回款时间：--";
        }else{
            self.detailLabl.text=[NSString stringWithFormat:@"预计回款时间%@",model.repTime];
        }
    }
    switch (model.paymentStatus) {
        case 1://回款逾期
        {
            self.stateLab.text=@"回款逾期";
            self.stateLab.textColor=RGB(0xFF2C2C);
        }
            break;
        case 2://待结算
        {
            self.stateLab.text=@"待结算";
            self.stateLab.textColor=RGB(0x3379EA);
        }
            break;
        case 3://七日内到账
        {
            self.stateLab.text=@"七日内到期";
            self.stateLab.textColor=RGB(0xFF7F1B);
        }
            break;
        case 4://待回款
        {
            self.stateLab.text=@"待回款";
            self.stateLab.textColor=RGB(0xFF7F1B);
        }
            break;
        case 5://已回款
        {
            self.stateLab.text=@"已回款";
            self.stateLab.textColor=RGB(0x999999);
        }
            break;
            
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
