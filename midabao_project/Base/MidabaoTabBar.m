//
//  MidabaoTabBar.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MidabaoTabBar.h"
static MidabaoTabBar *tabbar=nil;
@interface MidabaoTabBar ()<UITabBarControllerDelegate>
{
    NSUInteger _index;
}
@end

@implementation MidabaoTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    self.tabBar.backgroundImage = [self imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SYS_TABBARSHDOWHEIGHT, UISCREEN_WIDTH, 49-SYS_TABBARSHDOWHEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView *boardShdow=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, SYS_TABBARSHDOWHEIGHT)];
    boardShdow.image=[UIImage imageNamed:@"tabbarshdow"];
    [self.tabBar insertSubview:boardShdow atIndex:0];
    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.tintColor=RGB(0x3379EA);
//    self.tabBar.unselectedItemTintColor=RGB(0x7C89A8);
//    self.tabBarItem.imageInsets=;
//    self.tabBarController.tabBarItem.
    self.tabBar.opaque = YES;
    self.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;//iOS7后自定义tabbar 于系统的tabar冲突
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
