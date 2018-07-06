//
//  UIImageView+LoadImage.m
//  YouRong_Project
//
//  Created by Yuanin on 16/6/2.
//  Copyright © 2016年 YouRong. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImageView+AFNetworking.h"

@implementation UIImageView (LoadImage)

- (void)loadImageWithPath:(NSString *)path {
    [self setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"default_image"]];
}

-(void)loadHeadImageWithPath:(NSString *)path{
    [self setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"user_avatar_log"]];
}
-(void)loadbnnerImageWithPath:(NSString *)path{
    [self setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"bannerMorenIcon"]];
}


-(void)loadFKImageWithPath:(NSString *)path{
    [self setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"fkbeijingIcon"]];
}
@end
