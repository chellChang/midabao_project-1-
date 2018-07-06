//
//  UIView+Frame.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)width {
    
    return CGRectGetWidth(self.bounds);
}
- (CGFloat)height {
    
    return CGRectGetHeight(self.bounds);
}
- (CGFloat)x {
    
    return self.frame.origin.x;
}
- (CGFloat)y {
    
    return self.frame.origin.y;
}
- (CGPoint)origin {
    
    return self.frame.origin;
}
- (CGSize)size {
    
    return self.frame.size;
}
@end
