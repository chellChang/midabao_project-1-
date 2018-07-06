
//
//  UsedCouponTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UsedCouponTVCell.h"
@interface UsedCouponTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *limtLab;
@property (weak, nonatomic) IBOutlet UILabel *investMoney;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *currentstate;

@end
@implementation UsedCouponTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subView.layer.cornerRadius=4;
    self.subView.layer.masksToBounds=YES;
}
-(void)configureUIWithData:(couponrModel *)model{
    if (model.couponType==2) {//满减券
        NSString *manjianStr=[NSString stringWithFormat:@"￥%.0f",model.couponPrice];
        NSMutableAttributedString * stringmj = [[NSMutableAttributedString alloc]initWithString:manjianStr];
        //设置颜色不同
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, manjianStr.length-1)];
        self.money.attributedText=stringmj;
        self.titleLab.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用限制：%@",model.proName];
        self.investMoney.text=[NSString stringWithFormat:@"投资金额：满%ld元可用",model.investPriceUp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.dateTime.text=[NSString stringWithFormat:@"有效期至：%@",dateTime];
    }else if(model.couponType==1){//加息券
        NSString *strjiaxi=[NSString stringWithFormat:@"+%.1f%%",model.couponPrice];
        NSMutableAttributedString * stringjx = [[NSMutableAttributedString alloc]initWithString:strjiaxi];
        //设置颜色不同
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, strjiaxi.length-1)];
        self.money.attributedText=stringjx;
        self.titleLab.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用规则：%@",model.proName];
        self.investMoney.text=[NSString stringWithFormat:@"加息天数：%ld天",model.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.dateTime.text=[NSString stringWithFormat:@"有效期至:%@",dateTime];
    }else if (model.couponType==3){//体验金
        NSString *tiyanjinStr=[NSString stringWithFormat:@"￥%.0f",model.couponPrice];
        NSMutableAttributedString * stringtyj = [[NSMutableAttributedString alloc]initWithString:tiyanjinStr];
        [stringtyj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:12]} range:NSMakeRange(0, 1)];
        [stringtyj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:18]} range:NSMakeRange(1, tiyanjinStr.length-1)];
        self.money.attributedText=stringtyj;
        self.titleLab.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用规则：%@",model.proName];
        self.investMoney.text=[NSString stringWithFormat:@"体验天数：%ld天",model.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.dateTime.text=[NSString stringWithFormat:@"有效期至：%@",dateTime];
    }
    self.currentstate.text=model.useStatus==0?@"已使用":@"已过期";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
