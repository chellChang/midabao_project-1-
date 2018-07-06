//
//  InvitePeopleRuleWebVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvitePeopleRuleWebVC.h"
#import <MessageUI/MessageUI.h>
#import "ShareView.h"
#import "UserInfoManager.h"
#import "LoginNavigationVController.h"
@interface InvitePeopleRuleWebVC ()<MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) UIButton *inviteFriend;
@property (strong, nonatomic) ShareView *shareView;
@end

@implementation InvitePeopleRuleWebVC
-(instancetype)initWithWebPath:(NSString *)webPath{
    if (self=[super initWithWebPath:webPath]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.inviteFriend];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0);
    // Do any additional setup after loading the view.
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.inviteFriend.translatesAutoresizingMaskIntoConstraints) {
        self.inviteFriend.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inviteFriend]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.inviteFriend}];
        NSArray *vButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[inviteFriend(==48)]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.inviteFriend}];
        
        [self.view addConstraints:hButCon];
        [self.view addConstraints:vButCon];
    }
}
- (UIButton *)inviteFriend {
    
    if (!_inviteFriend) {
        _inviteFriend = [[UIButton alloc] init];
        
        _inviteFriend.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _inviteFriend.backgroundColor=BtnColor;
        [_inviteFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteFriend setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_inviteFriend addTarget:self action:@selector(fastInviteFriend) forControlEvents:UIControlEventTouchUpInside];
        
//        if (![SharedWechatView canShared]) {
//            [_inviteFriend setTitle:@"您未安装可分享软件" forState:UIControlStateNormal];
//            _inviteFriend.enabled = NO;
//        _inviteFriend.backgroundColor=BtnUnColor;
//        }
    }
    return _inviteFriend;
}
- (void)fastInviteFriend {
    if (![UserInfoManager shareUserManager].logined) {
        [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        return;
    }
    self.shareView=[ShareView sharedWechatViewWithURL:[NSString stringWithFormat:@"%@%@%@",ShareHostUrl,SharesubUrl,[UserInfoManager shareUserManager].userInfo.userid] title:@"米小贝金服送你688元红包，邀你一起轻松赚钱！" description:@"加入立拿688元红包，还有4%加息券以及高年化新手标等你来投！" thumbImagePath:@""];
    if ([self.shareView canShared]) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        
        [self.shareView showInWindow:window];
        @weakify(self)
        self.shareView.selectShareBlock = ^(BOOL isshare) {
            @strongify(self)
            if (isshare) {
                [self goshareMessage];
            }else{
                [AlertViewManager showInViewController:self title:@"温馨提示" message:@"未安装分享软件，是否去AppStore商店下载分享软件？" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            }
            
        };
    }else{
        [self goshareMessage];
    }


}
-(void)goshareMessage{
    if( [MFMessageComposeViewController canSendText] )
    {
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        MFMessageComposeViewController  *controller = [[MFMessageComposeViewController alloc] init];
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = [NSString stringWithFormat:@"米小贝金服送你688元红包，邀你一起轻松赚钱！\n加入立拿688元红包，还有4%%加息券以及高年化新手标等你来投！欢迎戳此链接：%@%@%@",ShareHostUrl,SharesubUrl,[UserInfoManager shareUserManager].userInfo.userid];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            [BaseIndicatorView hide];
        }];
    }
    else
    {
        [AlertViewManager showInViewController:self title:@"提示信息" message:@"该设备不支持短信功能" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch(result) {
        case
        MessageComposeResultSent:
            [SpringAlertView showMessage:@"信息发送成功"];
            break;
        case
        MessageComposeResultFailed:
            [SpringAlertView showMessage:@"信息发送失败"];
            break;
        case
        MessageComposeResultCancelled:
            [SpringAlertView showMessage:@"信息被取消发送"];
            break;
        default:
            break;
    }
    
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
