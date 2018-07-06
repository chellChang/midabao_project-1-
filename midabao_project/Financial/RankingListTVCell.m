//
//  RankingListTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "RankingListTVCell.h"
#import "NSString+ExtendMethod.h"
@interface RankingListTVCell()
@property (weak, nonatomic) IBOutlet UIView *InsubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insubviewHeight;

@end
@implementation RankingListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configureui:(NSArray *)arr{

    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=arr[i];
        UILabel *name=[self.contentView viewWithTag:1130+i];
        UILabel *money=[self.contentView viewWithTag:1140+i];
  
        name.text=[CommonTools convertToStringWithObject:dic[@"userName"]];
        NSString *inviteStr=[NSString stringWithFormat:@"累计投资%@元",[CommonTools converFloatForFormatMoney:[dic[@"invPrice"] doubleValue]]];
        money.font=[UIFont fontWithName:@"SFUIText-Regular" size:16];
        money.attributedText=[inviteStr changeAttributeStringWithAttribute:@{NSForegroundColorAttributeName:RGB(0x333333)} Range:NSMakeRange(4, inviteStr.length-4)];
    }
    
    UIImageView  *inventIcon=[self.contentView viewWithTag:1121];
    UILabel *name=[self.contentView viewWithTag:1131];
    UILabel *money=[self.contentView viewWithTag:1141];
    UIImageView  *inventIcon1=[self.contentView viewWithTag:1122];
    UILabel *name1=[self.contentView viewWithTag:1132];
    UILabel *money1=[self.contentView viewWithTag:1142];
    if (arr.count<2) {//只有一个
        inventIcon.hidden=YES;
        name.hidden=YES;
        money.hidden=YES;
        inventIcon1.hidden=YES;
        name1.hidden=YES;
        money1.hidden=YES;
        self.insubviewHeight.constant=56;
    }else if (arr.count<3){//只有两个
        inventIcon1.hidden=YES;
        name1.hidden=YES;
        money1.hidden=YES;
        self.insubviewHeight.constant=102;
    }else{
        self.insubviewHeight.constant=150;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
