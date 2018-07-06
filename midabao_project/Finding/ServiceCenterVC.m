//
//  ServiceCenterVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ServiceCenterVC.h"

@interface ServiceCenterVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *WXGZHBtn;
@property (weak, nonatomic) IBOutlet UIButton *KFEmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *KFQQBtn;
@property (weak, nonatomic) IBOutlet UIButton *KFWXBtn;

@end

@implementation ServiceCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.WXGZHBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.KFEmailBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.KFQQBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.KFWXBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
}
//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = RGBA(0x000000, 0.15);
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.backgroundColor = [UIColor whiteColor];
    } completion:nil];
}
- (IBAction)clickPhone:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4008520612"]];
}
- (IBAction)clickKFWX:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=@"542458815";
    [AlertViewManager showInViewController:self title:@"复制成功" message:@"进入微信搜索好友页面，粘贴并搜索客服微信，添加客服好友，客服会第一时间为您服务。" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSURL * url = [NSURL URLWithString:@"weixin://wxf82426270ea154f2"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            if (canOpen)
            {   //打开微信
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [SpringAlertView showMessage:@"打开失败，请手动打开微信粘贴"];
            }
        }
    } cancelButtonTitle:@"关闭" otherButtonTitles:@"打开微信", nil];
}
- (IBAction)clickKFQQ:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=@"542458815";
    [AlertViewManager showInViewController:self title:@"复制成功" message:@"进入QQ搜索好友页面，粘贴并搜索客服QQ，添加客服好友，客服会第一时间为您服务。" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
            NSURL *url = [NSURL URLWithString:urlStr];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wpa.qq.com/msgrd?v=3&uin=1219756152&site=qq&menu=yes"]];
            }
        }
    } cancelButtonTitle:@"关闭" otherButtonTitles:@"打开QQ", nil];
}
- (IBAction)clickKFEmail:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=@"support@mixiaobei.com";
    [AlertViewManager showInViewController:self title:@"复制成功" message:@"发送邮件至support@mixiaobei.com，客服将第一时间为您服务。" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
    } cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
}
- (IBAction)clickWXGZH:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=@"mixiaobeijinfu";
    [AlertViewManager showInViewController:self title:@"复制成功" message:@"进入微信搜索页面，粘贴并搜索微信公众号，点击关注，即可关注米小贝官方微信号。" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSURL * url = [NSURL URLWithString:@"weixin://wxf82426270ea154f2"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            if (canOpen)
            {   //打开微信
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [SpringAlertView showMessage:@"打开失败，请手动打开微信粘贴"];
            }

        }
    } cancelButtonTitle:@"关闭" otherButtonTitles:@"打开微信", nil];
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
