//
//  UIImageView+LoadImage.h
//  YouRong_Project
//
//  Created by Yuanin on 16/6/2.
//  Copyright © 2016年 YouRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

/**
 加载普通的图片

 @param path ImageUrl
 */
- (void)loadImageWithPath:(NSString *)path;

/**
 加载头像的path

 @param path ImageUrl
 */
-(void)loadHeadImageWithPath:(NSString *)path;


-(void)loadbnnerImageWithPath:(NSString *)path;


-(void)loadFKImageWithPath:(NSString *)path;
@end
