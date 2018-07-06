//
//  FKZLTVCell.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/30.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "FKZLTVCell.h"
#import "UIImageView+LoadImage.h"
#import "PYPhotoBrowser.h"
@interface FKZLTVCell()
@property (weak, nonatomic) IBOutlet UIView *FKsubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FKsubViewHeight;
@end
@implementation FKZLTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configreUiData:(NSArray *)arr{
    
    NSMutableArray *thumbanArr=[NSMutableArray arrayWithCapacity:0];
    for (NSString *url in arr) {
        NSArray *arr=[url componentsSeparatedByString:@"."];
        NSMutableString *newUrl=[url mutableCopy];
        [newUrl insertString:@"_1" atIndex:newUrl.length-([[arr lastObject] length]+1)];
        [thumbanArr addObject:newUrl];
        
    }
    CGFloat width=(UISCREEN_WIDTH-16*4)/3;
    CGFloat space=16;
    CGFloat start_x=16;
    CGFloat start_y=16;

//    // 2.1 创建一个流水布局photosView(默认为流水布局)
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.placeholderImage=[UIImage imageNamed:@"fkbeijingIcon"];
    // 设置缩略图数组
    flowPhotosView.thumbnailUrls = thumbanArr;
    // 设置原图地址
    flowPhotosView.originalUrls =arr ;
    // 设置分页指示类型
    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    flowPhotosView.py_y=start_y;
    flowPhotosView.py_x=self.FKsubView.origin.x+start_x;
    flowPhotosView.photoMargin = space;
    flowPhotosView.photoWidth = width;
    flowPhotosView.photoHeight = width;
    flowPhotosView.photosMaxCol = 3;
    flowPhotosView.autoRotateImage = NO;
    flowPhotosView.showDuration=0.3;
    flowPhotosView.hiddenDuration=0.3;
    [self.FKsubView addSubview:flowPhotosView];
    self.FKsubViewHeight.constant=flowPhotosView.frame.size.height+flowPhotosView.frame.origin.y+16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
