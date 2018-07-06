//
//  SignListTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "SignListTVCell.h"
@interface SignListTVCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *jifengLab;

@end
@implementation SignListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configuiWithData:(IntegralModel *)Model{
    self.contentLab.text=Model.integYype==1?@"签到":@"使用积分";
    NSDate  *date1 = [NSDate dateWithTimeIntervalSince1970:[Model.time integerValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
//    NSDate *date=[formatter dateFromString:@"1503627906000"];
    NSString *dateTime = [formatter stringFromDate:date1];
    self.dateLab.text=[NSString stringWithFormat:@"%@",dateTime];
    self.jifengLab.text=Model.integStatus==1?[NSString stringWithFormat:@"+%ld",Model.integral]:[NSString stringWithFormat:@"-%ld",Model.integral];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
