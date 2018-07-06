//
//  MidabaoApplication.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 缓存文件名称
//***********************缓存文件名称
static NSString *bannerPath    = @"banner.archiver";
static NSString *recommendPath = @"recommend.archiver";
static NSString *productsPath  = @"products.archiver";
static NSString *bankCardPath  = @"bankcard_list.archiver";
@interface MidabaoApplication : NSObject
+ (instancetype)shareMidabaoApplication;


@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

/**
 *  对app进行初始化设置
 *
 */
- (void)initializeApplicationWithOptions:(NSDictionary *)launchOptions;

/**
 *  获取storyboard的ViewController
 *
 *  @param name       storyboard的名称, not nil
 *  @param VCIdentity viewControlelr在Storyboard上的ID
 *
 *  @return 获取到的viewController
 */
- (id)obtainControllerForStoryboard:(NSString *)name controller:(NSString *)VCIdentity;

/**
 *  同上，name默认为Main
 */
- (id)obtainControllerForMainStoryboardWithID:(NSString *)VCIdentity;

/**
 *  判断是否设置手势密码
 *
 *  @return 是否设置手势密码
 */
- (BOOL)haveGesturePassword;

/**
 *  @param fileName 文件名
 *
 *  @return 在caches 下的fileName的路径
 */
- (NSString *)pathForCachesWithFileName:(NSString *)fileName;

@end
