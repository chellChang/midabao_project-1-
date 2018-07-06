//
//  CouponTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/11.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "CouponTVCell.h"
#import "NSString+ExtendMethod.h"
@interface CouponTVCell()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *limtLab;
@property (weak, nonatomic) IBOutlet UILabel *dislba;
@property (weak, nonatomic) IBOutlet UILabel *effecTime;
@property (weak, nonatomic) IBOutlet UIButton *usedCouponBtn;
@property (weak, nonatomic) IBOutlet UILabel *disUsedLab;
@property (nonatomic,strong)couponrModel *model;
@end
@implementation CouponTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backSubView.layer.cornerRadius=4;
    self.backSubView.layer.masksToBounds=YES;
//    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.backView.layer.shadowOffset = CGSizeMake(0,3);
//    self.backView.layer.shadowRadius = 4;
//    self.backView.layer.shadowOpacity = 0.1;

    // Initialization code
}
-(void)configureUIwithD:(couponrModel *)model{
    self.usedCouponBtn.hidden=YES;
    self.model=model;
    if (model.couponType==2) {//满减券
        
        NSString *manjianStr=[NSString stringWithFormat:@"￥%.0f",model.couponPrice];
        NSMutableAttributedString * stringmj = [[NSMutableAttributedString alloc]initWithString:manjianStr];
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, manjianStr.length-1)];
        self.money.attributedText=stringmj;
        self.title.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用限制：%@",model.proName];
        self.dislba.text=[NSString stringWithFormat:@"投资金额：满%ld元可用",model.investPriceUp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.effecTime.text=[NSString stringWithFormat:@"有效期至：%@",dateTime];
    }else if(model.couponType==1){//加息券
        
        NSString *strjiaxi=[NSString stringWithFormat:@"+%.1f%%",model.couponPrice];
        NSMutableAttributedString * stringjx = [[NSMutableAttributedString alloc]initWithString:strjiaxi];
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, strjiaxi.length-1)];
        self.money.attributedText=stringjx;
        self.title.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用规则：%@",model.proName];
        self.dislba.text=[NSString stringWithFormat:@"加息天数：%ld天",model.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.effecTime.text=[NSString stringWithFormat:@"有效期至:%@",dateTime];
    }
    if (model.useStatus==1&&model.isAva==1){//可用
        self.money.textColor=RGB(0xFF2C2C);
        self.title.textColor=RGB(0x333333);
        self.limtLab.textColor=RGB(0x333333);
        self.dislba.textColor=RGB(0x333333);
        self.chooseImg.hidden=NO;
        self.disUsedLab.hidden=YES;
    }else{//不可用
        self.money.textColor=RGB(0x999999);
        self.title.textColor=RGB(0x999999);
        self.limtLab.textColor=RGB(0x999999);
        self.dislba.textColor=RGB(0x999999);
        self.chooseImg.hidden=YES;
        self.disUsedLab.hidden=NO;
        if (model.useStatus==0) {
            self.disUsedLab.text=@"已使用";
        }else if (model.useStatus==2){
            self.disUsedLab.text=@"已过期";
        }else{
            self.disUsedLab.text=@"不可用";
        }
    }
}
-(void)configuremyallcouponwithdata:(couponrModel *)model{
    self.disUsedLab.hidden=YES;
    self.chooseImg.hidden=YES;
    self.model=model;
    if (model.couponType==2) {//满减券
        NSLog(@"--(%lf)",model.couponPrice);
        
        
        NSString *manjianStr=[NSString stringWithFormat:@"￥%.0f",model.couponPrice];
        NSMutableAttributedString * stringmj = [[NSMutableAttributedString alloc]initWithString:manjianStr];
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringmj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, manjianStr.length-1)];
        self.money.attributedText=stringmj;
        self.title.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用限制：%@",model.proName];
        self.dislba.text=[NSString stringWithFormat:@"投资金额：满%ld元可用",model.investPriceUp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.effecTime.text=[NSString stringWithFormat:@"有效期至：%@",dateTime];
    }else if(model.couponType==1){//加息券
        NSString *strjiaxi=[NSString stringWithFormat:@"+%.1f%%",model.couponPrice];
        NSMutableAttributedString * stringjx = [[NSMutableAttributedString alloc]initWithString:strjiaxi];
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:16]} range:NSMakeRange(0, 1)];
        [stringjx addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:28]} range:NSMakeRange(1, strjiaxi.length-1)];
        self.money.attributedText=stringjx;
        self.title.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用规则：%@",model.proName];
        self.dislba.text=[NSString stringWithFormat:@"加息天数：%ld天",model.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.effecTime.text=[NSString stringWithFormat:@"有效期至:%@",dateTime];
    }else if (model.couponType==3){//体验金
        NSString *tiyanjinStr=[NSString stringWithFormat:@"￥%.0f",model.couponPrice];
        NSMutableAttributedString * stringtyj = [[NSMutableAttributedString alloc]initWithString:tiyanjinStr];
        [stringtyj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:12]} range:NSMakeRange(0, 1)];
        [stringtyj addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Medium" size:18]} range:NSMakeRange(1, tiyanjinStr.length-1)];
        self.money.attributedText=stringtyj;
        self.title.text=model.couponName;
        self.limtLab.text=[NSString stringWithFormat:@"使用规则：%@",model.proName];
        self.dislba.text=[NSString stringWithFormat:@"体验天数：%ld天",model.day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateTime = [formatter stringFromDate:model.effecTime];
        self.effecTime.text=[NSString stringWithFormat:@"有效期至：%@",dateTime];
    }
}
- (IBAction)clickUseCouponBtn:(id)sender {
    !self.usedcoupon?:self.usedcoupon(self.model.couponrId);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
