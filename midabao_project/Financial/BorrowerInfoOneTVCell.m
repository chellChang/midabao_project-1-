//
//  BorrowerInfoOneTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BorrowerInfoOneTVCell.h"
@interface BorrowerInfoOneTVCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idCard;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *localLab;

@end
@implementation BorrowerInfoOneTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureUIWithData:(NSArray *)arr{
    NSDictionary *dic=[arr firstObject];
    self.name.text=dic[@"borrowerName"];
    self.idCard.text=[CommonTools convertToStringWithObject:dic[@"identityCard"]];
    self.ageLab.text=[NSString stringWithFormat:@"%@岁",[CommonTools convertToStringWithObject:dic[@"age"]]];
    self.localLab.text=dic[@"address"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
