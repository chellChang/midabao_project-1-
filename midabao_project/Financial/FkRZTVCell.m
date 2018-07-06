//
//  FkRZTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FkRZTVCell.h"
@interface FkRZTVCell()
@property (weak, nonatomic) IBOutlet UIView *FKsubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FKsubviewHeight;

@end
@implementation FkRZTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)confogureUIWithData:(NSArray *)arr{
    self.FKsubviewHeight.constant=46+((arr.count/2+arr.count%2)-1)*30;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=arr[i];
        UIImageView *ItemImg;
        UILabel *lable;
        if (i%2!=0) {
            ItemImg=[[UIImageView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2.0,16+30*(i/2), 14, 14)];
            lable=[[UILabel alloc]initWithFrame:CGRectMake(ItemImg.frame.origin.x+ItemImg.frame.size.width+10, ItemImg.frame.origin.y,  UISCREEN_WIDTH/2.0-(ItemImg.frame.size.width+10-5),14)];
        }else{
            ItemImg=[[UIImageView alloc]initWithFrame:CGRectMake(16,16+30*(i/2), 14, 14)];
            lable=[[UILabel alloc]initWithFrame:CGRectMake(ItemImg.frame.origin.x+ItemImg.frame.size.width+10, ItemImg.frame.origin.y,  UISCREEN_WIDTH/2.0-(ItemImg.frame.origin.x+ItemImg.frame.size.width+10-5),14)];
        }
        
        lable.textColor=RGB(0X666666);
        lable.font=[UIFont systemFontOfSize:14];
        [self.FKsubView addSubview:ItemImg];
        [self.FKsubView addSubview:lable];
        lable.text=dic[@"extnedName"];
        ItemImg.image=[UIImage imageNamed:@"renzhengIcon"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
