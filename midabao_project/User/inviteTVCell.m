//
//  inviteTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/22.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "inviteTVCell.h"
@interface inviteTVCell()
@property (weak, nonatomic) IBOutlet UILabel *inviteName;
@property (weak, nonatomic) IBOutlet UILabel *inviteMoney;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end
@implementation inviteTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)inviteFriendWithData:(InvitefriendModel *)model{
    self.inviteName.text=model.phone;
    self.inviteMoney.text=model.totalAssets;
    self.money.text=model.balance;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
