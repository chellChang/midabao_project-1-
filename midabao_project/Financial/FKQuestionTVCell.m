//
//  FKQuestionTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FKQuestionTVCell.h"
@interface FKQuestionTVCell()
@property (weak, nonatomic) IBOutlet UILabel *questTitle;
@property (weak, nonatomic) IBOutlet UILabel *questContent;

@end
@implementation FKQuestionTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configurUI:(questModel *)model{
    self.questTitle.text=model.problem;
    NSString *answerStr=[model.answer stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.questContent.text=answerStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
