//
//  ProjectListModel.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/25.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ProjectListModel.h"

@implementation ProjectListModel
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _homeProjectId=[CommonTools convertToStringWithObject:dic[@"id"]];
    return YES;
}
@end
