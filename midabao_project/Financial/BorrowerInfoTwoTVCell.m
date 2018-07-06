//
//  BorrowerInfoTwoTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BorrowerInfoTwoTVCell.h"

@implementation BorrowerInfoTwoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark ---查看更多借款人
- (IBAction)seeMoreBorrower:(id)sender {
    
    
}
-(void)configureUIwithData:(NSArray *)arr{
    
    NSInteger allCount=arr.count>3?3:arr.count;
    for (int i=0; i<allCount; i++) {
        NSDictionary *dic=arr[i];
        UILabel *name=[self.contentView viewWithTag:110+i];
        UILabel *idCard=[self.contentView viewWithTag:120+i];
        UILabel *money=[self.contentView viewWithTag:130+i];
        name.text=dic[@"borrowerName"];
        idCard.text=[CommonTools convertToStringWithObject:dic[@"identityCard"]];
        money.text=[CommonTools convertToStringWithObject:dic[@"loanPrice"]];
    }
    UILabel *names=[self.contentView viewWithTag:112];
    UILabel *idCards=[self.contentView viewWithTag:122];
    UILabel *moneys=[self.contentView viewWithTag:132];
    UIButton *btns=[self.contentView viewWithTag:140];
    if (arr.count<3) {//只有两个
        names.hidden=YES;
        idCards.hidden=YES;
        moneys.hidden=YES;
        btns.hidden=YES;
    }else if (arr.count<4){//只有三个
        btns.hidden=YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
