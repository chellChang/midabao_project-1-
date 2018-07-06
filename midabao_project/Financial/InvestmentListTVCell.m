//
//  InvestmentListTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvestmentListTVCell.h"
@interface InvestmentListTVCell()
@property (weak, nonatomic) IBOutlet UIImageView *investIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *investTime;

@end
@implementation InvestmentListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureUi:(investmentModel *)model{
    self.investIcon.image=model.source==1?[UIImage imageNamed:@"appleIcon"]:[UIImage imageNamed:@"androidIcon"];
    self.name.text=model.userName;
    self.money.text=[NSString stringWithFormat:@"%@元",[CommonTools converFloatForFormatMoney:model.invPrice]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
//    self.investTime.text=[formatter stringFromDate:model.invTime];
    self.investTime.text=[self getNowDay:[formatter stringFromDate:model.invTime]];
    
}
// 获取当前是星期几
- (NSString*)getNowDay:(NSString*)currentStr

{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy.MM.dd HH:mm"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    NSDateComponents *nowComponents=[calendar components:calendarUnit fromDate:[NSDate date]];
    if (nowComponents.day==theComponents.day) {
        NSDateFormatter *currentformat=[[NSDateFormatter alloc]init];
        [currentformat setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@",[currentformat stringFromDate:date]];
    }else if (nowComponents.day-1==theComponents.day){
        NSDateFormatter *currentformat=[[NSDateFormatter alloc]init];
        [currentformat setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[currentformat stringFromDate:date]];
    }

    return [dateFormat stringFromDate:date];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
