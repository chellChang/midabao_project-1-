
//
//  CostomPageCol.m
//  YouRong_Project
//
//  Created by Yuanin2 on 2017/4/10.
//  Copyright © 2017年 YouRong. All rights reserved.
//

#import "CostomPageCol.h"
@implementation CostomPageCol
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(instancetype)init{
    self=[super init];
    if (self) {
    }
    return self;
}
-(void) updateDots{
    for (int i = 0; i < [self.subviews count]; i++)
       {
           UIView* dot = [self.subviews objectAtIndex:i];
           dot.frame=CGRectMake(0, 0, 20, 4);
           dot.backgroundColor=[UIColor clearColor];
           UIImageView *dotimg=[[dot subviews]firstObject];
           if (!dotimg) {
               dotimg=[[UIImageView alloc]init];
               dotimg.frame=CGRectMake(0, 0, dot.frame.size.width, dot.frame.size.height);
               [dot addSubview:dotimg];
           }
           if (i == self.currentPage){
               dotimg.image=self.activeImg;
               
           }else{
               dotimg.image=self.inactiveImg;
           }
    }
}
-(void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
