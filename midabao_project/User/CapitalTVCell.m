//
//  CapitalTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "CapitalTVCell.h"
@interface CapitalTVCell ()
@property (weak, nonatomic) IBOutlet UILabel *xiqiLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIImageView *capitalIcon;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *explanLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateWidthCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explotHeightCos;

@end
@implementation CapitalTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.explotHeightCos.constant = [self.explanLab.text boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH - 141, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}
-(void)configureData:(capitalDetailModel *)model{
    self.xiqiLab.text=[self getWeekDay:model.crateTime];
    self.dateLab.text=model.crateTime;
    switch (model.type) {
        case 1:
            self.capitalIcon.image=[UIImage imageNamed:@"capitalReachIcon"];
            break;
        case 2:
            self.capitalIcon.image=[UIImage imageNamed:@"capitaltixianIcon"];
            break;
        case 3:
            self.capitalIcon.image=[UIImage imageNamed:@"capitaltouziIcon"];
            break;
        case 4:
            self.capitalIcon.image=[UIImage imageNamed:@"capitalhuikuanIcon"];
            break;
        default:
            self.capitalIcon.image=[UIImage imageNamed:@"capitaljangliicon"];
            break;
    }
    self.moneyLab.text=[NSString stringWithFormat:@"%@%@",model.capitaloperator==1?@"+":@"-",[CommonTools converFloatForFormatMoney:model.price]];
    self.explanLab.text=model.transExplain;
    switch (model.transStatus) {
        case 1:
        {
            self.stateLab.text=@"处理中";
            self.stateWidthCos.constant=38;
            self.stateLab.textColor=RGB(0xFF7F1B);
        }
            break;
        case 2:
        {
            self.stateLab.text=@"";
            self.stateWidthCos.constant=0;
        }
            break;
        case 3:
        {
            self.stateLab.text=@"交易失败";
            self.stateWidthCos.constant=50;
            self.stateLab.textColor=RGB(0x999999);
        }
            break;
        default:
            break;
    }
}

// 获取当前是星期几
- (NSString*)getWeekDay:(NSString*)currentStr

{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"MM.dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    NSDateComponents *nowComponents=[calendar components:calendarUnit fromDate:[NSDate date]];
    if (nowComponents.weekday==theComponents.weekday) {
        return @"今天";
    }else if (nowComponents.weekday-1==theComponents.weekday){
        return @"昨天";
    }
    return[weekdays objectAtIndex:theComponents.weekday];
    
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
