//
//  MessageForwarder.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageForwarder : NSObject

@property (nonatomic, strong) IBOutletCollection(id) NSArray* delegateTargets;

@end
