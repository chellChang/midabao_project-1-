//
//  ProjectDateTopTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectDateTopTVCell.h"

@implementation ProjectDateTopTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createUiwithState:(NSInteger)state andTime:(NSString *)time{
    if (state==0) {
        self.buyTime.text=[NSString stringWithFormat:@"购买时间：%@",time];
        self.topLineView.hidden=YES;
    }else if (state==1){
        self.topLineView.hidden=NO;
        self.buyTime.text=[NSString stringWithFormat:@"起息时间：%@",time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSDate *date=[formatter dateFromString:time];
        NSComparisonResult result=[[NSDate date] compare:date];
        if (result==NSOrderedAscending){
            self.topLineView.backgroundColor=RGB(0xAECAF7);
            self.bottomLineView.backgroundColor=RGB(0xAECAF7);
            self.pointImage.image=[UIImage imageNamed:@"bluePoint"];
            self.buyTime.textColor=RGB(0x999999);
        }else{
            self.topLineView.backgroundColor=RGB(0x3379EA);
            self.bottomLineView.backgroundColor=RGB(0x3379EA);
            self.pointImage.image=[UIImage imageNamed:@"deepbluePoint"];
            self.buyTime.textColor=RGB(0x333333);

        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
