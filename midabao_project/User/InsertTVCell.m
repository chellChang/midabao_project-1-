//
//  InsertTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/14.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InsertTVCell.h"
#import "UILabel+Format.h"
#import "NSString+ExtendMethod.h"
@interface InsertTVCell()
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *limtDay;
@property (weak, nonatomic) IBOutlet UIImageView *nowState;
@property (weak, nonatomic) IBOutlet UILabel *investMoney;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *investTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@end
@implementation InsertTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureUIWithData:(myinvestlistModel *)model{
    if (model.projectStatus==6||model.projectStatus==8||model.projectStatus==10) {//回款中
        if (model.projectStatus==6) {//已满标
            self.nowState.image=[UIImage imageNamed:@"yimanbiaoIcon"];
        }else if(model.projectStatus==10){//逾期
            self.nowState.image=[UIImage imageNamed:@"yuqibiaoIcon"];
        }else{
            self.nowState.image=[UIImage imageNamed:@"huankaunzhongIcon"];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        if (model.repDays!=nil&&![model.repDays isKindOfClass:[NSNull class]]) {
            NSString *timestr=[NSString stringWithFormat:@"%@到期 项目剩余%@天",[formatter stringFromDate:model.repTime],model.repDays];
            self.endTime.attributedText=[timestr changeAttributeStringWithAttribute:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} Range:NSMakeRange(timestr.length-1-model.repDays.length, model.repDays.length)];
        }else{
            self.endTime.text=@"回款时间待确定";
        }
        
        
    }else if (model.projectStatus==5){//募集中
        self.nowState.image=[UIImage imageNamed:@"mojizhongIcon"];
        NSArray *subArr=[[NSString dateTimeDifferenceWithStartTime:[NSDate date] endTime:model.entTime andaccuracy:2] componentsSeparatedByString:@"-"];
        NSString *timestr=@"";
        NSString *daystr=@"";
        NSString *houseStr=@"";
        if (subArr.count>1) {
            daystr=subArr[0];
            houseStr=subArr[1];
            if ([daystr isEqualToString:@"0"]&&[houseStr isEqualToString:@"0"]) {
                daystr=@"";
                houseStr=@"1";
                timestr=[NSString stringWithFormat:@"募集剩余时间：小于1小时"];
            }else if([daystr isEqualToString:@"0"]&&![houseStr isEqualToString:@"0"]){
                daystr=@"";
                timestr=[NSString stringWithFormat:@"募集剩余时间：%@小时",houseStr];
            }else if (![daystr isEqualToString:@"0"]&&![houseStr isEqualToString:@"0"]){
                timestr=[NSString stringWithFormat:@"募集剩余时间：%@天%@小时",daystr,houseStr];
            }
            
        }else if (subArr.count>0){
            daystr=subArr[0];
            timestr=[NSString stringWithFormat:@"募集剩余时间：%@天",daystr];
        }
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:timestr];
        //设置颜色不同
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timestr.length-2-houseStr.length, houseStr.length)];
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timestr.length-2-houseStr.length-1-daystr.length, daystr.length)];
        self.endTime.attributedText=string;
    }else if (model.projectStatus==7||model.projectStatus==9){//已流标,已结清
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        if (model.projectStatus==7) {
            self.nowState.image=[UIImage imageNamed:@"yiliubiaoIcon"];
            if (model.lossTime!=nil&&![model.lossTime isKindOfClass:[NSNull class]]) {
                self.endTime.text=[NSString stringWithFormat:@"%@已流标",[formatter stringFromDate:model.lossTime]];
            }else{
                self.endTime.text=[NSString stringWithFormat:@"已流标"];
            }
            
            
        }else if (model.projectStatus==9){
            self.nowState.image=[UIImage imageNamed:@"yijieqingIcon"];
            if (model.entTime!=nil&&![model.entTime isKindOfClass:[NSNull class]]) {
                self.endTime.text=[NSString stringWithFormat:@"%@已结清",[formatter stringFromDate:model.entTime]];
            }else{
                self.endTime.text=@"已结清";
            }
            
        }
    }
    self.projectName.text=model.proName;
    self.limtDay.text=[NSString stringWithFormat:@"%ld%@",model.term,model.termCompany==1?@"天":@"个月"];
    [self.investMoney floatformatNumber:[NSString stringWithFormat:@"%.2lf",model.invPrice] andSubText:@""];
    if (model.addInterestRate>0) {
        self.rateLab.text=[NSString stringWithFormat:@"%.1lf%%+%.1lf%%",model.interestRate,model.addInterestRate];
    }else{
        self.rateLab.text=[NSString stringWithFormat:@"%.1lf%%",model.interestRate];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    self.investTime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:model.invTime]];
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
