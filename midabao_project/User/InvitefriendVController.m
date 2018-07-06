
//
//  InvitefriendVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "InvitefriendVController.h"
#import "InvitePeopleRuleWebVC.h"
#import "ShareView.h"
#import <MessageUI/MessageUI.h>
#import "StateTableView.h"
#import "inviteTVCell.h"
#import "MJRefresh.h"
#import "InvitefriendViewModel.h"
#import "UserInfoManager.h"
#import "UInilViewCell.h"
@interface InvitefriendVController ()<MFMessageComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) ShareView *shareView;
@property (weak, nonatomic) IBOutlet StateTableView *inviteTableview;
@property (strong,nonatomic)InvitefriendViewModel *friendVModel;
@end

@implementation InvitefriendVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.inviteTableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0==self.friendVModel.allModels.count?1:self.friendVModel.allModels.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.friendVModel.allModels.count>0) {
        return 30;
    }
    return 225;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.friendVModel.allModels.count>0){
        return 8;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.friendVModel.allModels.count>0) {
        return 96;
    }
    return 58;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.friendVModel.allModels.count>0) {
        UIView *topView=[[UIView alloc]init];
        topView.backgroundColor=RGB(0XF2F4F6);
        UIView *titileView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, UISCREEN_WIDTH, 48)];
        titileView.backgroundColor=[UIColor whiteColor];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 48)];
        titleLab.font=[UIFont boldSystemFontOfSize:16];
        titleLab.text=@"我邀请的人";
        titleLab.textColor=RGB(0x333333);
        UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
        lineImage.image=[UIImage imageNamed:@"lineX_e5"];
        [titileView addSubview:lineImage];
        [titileView addSubview:titleLab];
        [topView addSubview:titileView];
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 58, UISCREEN_WIDTH, 38)];
        UILabel *namelab=[[UILabel alloc]initWithFrame:CGRectMake(16, 16, 70, 14)];
        namelab.font=[UIFont boldSystemFontOfSize:14];
        namelab.textColor=RGB(0x999999);
        namelab.text=@"邀请的人";
        UILabel *middleTitle=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2.0-35, 16, 70, 14)];
        middleTitle.font=[UIFont boldSystemFontOfSize:14];
        middleTitle.textAlignment=NSTextAlignmentCenter;
        middleTitle.textColor=RGB(0x999999);
        middleTitle.text=@"首投金额";
        UILabel *rightTitle=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH-16-90, 16, 90, 14)];
        rightTitle.font=[UIFont boldSystemFontOfSize:14];
        rightTitle.textColor=RGB(0x999999);
        rightTitle.text=@"奖励体验金";
        rightTitle.textAlignment=NSTextAlignmentRight;
        [bottomView addSubview:namelab];
        [bottomView addSubview:middleTitle];
        [bottomView addSubview:rightTitle];
        bottomView.backgroundColor=[UIColor whiteColor];
        [topView addSubview:bottomView];
        return topView;
    }else{
        UIView *topView=[[UIView alloc]init];
        topView.backgroundColor=RGB(0XF2F4F6);
        UIView *titileView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, UISCREEN_WIDTH, 48)];
        titileView.backgroundColor=[UIColor whiteColor];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, 100, 48)];
        titleLab.font=[UIFont boldSystemFontOfSize:16];
        titleLab.text=@"我邀请的人";
        titleLab.textColor=RGB(0x333333);
        UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
        lineImage.image=[UIImage imageNamed:@"lineX_e5"];
        [titileView addSubview:lineImage];
        [titileView addSubview:titleLab];
        [topView addSubview:titileView];
        return topView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.friendVModel.allModels.count>0) {
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        return view;
    }
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.friendVModel.allModels.count>0) {
        inviteTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([inviteTVCell class])];
        [cell inviteFriendWithData:self.friendVModel.allModels[indexPath.row]];
        return cell;
    }
    UInilViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UInilViewCell class])];
    return cell;
}

-(void)setInviteTableview:(StateTableView *)inviteTableview{
    _inviteTableview=inviteTableview;
    _inviteTableview.delegate=self;
    _inviteTableview.dataSource=self;
    [_inviteTableview registerNib:[UINib nibWithNibName:NSStringFromClass([inviteTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([inviteTVCell class])];
      [_inviteTableview registerNib:[UINib nibWithNibName:NSStringFromClass([UInilViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UInilViewCell class])];
    @weakify(self)
    _inviteTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.friendVModel fetchFirstPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.inviteTableview.mj_header endRefreshing];
            [self.inviteTableview reloadData];
            if ([result[RESULT_DATA][@"hasNextPage"] boolValue]) {
                self.inviteTableview.mj_footer.state=MJRefreshStateIdle;
            }else{
                self.inviteTableview.mj_footer.state=MJRefreshStateNoMoreData;
            }
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.inviteTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
    _inviteTableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
        [self.friendVModel fetchNextPageWithParams:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.inviteTableview.mj_footer endRefreshing];
            [self.inviteTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            [BaseIndicatorView hide];
            [self.inviteTableview.mj_footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
}

-(InvitefriendViewModel *)friendVModel{
    if (!_friendVModel) {
        _friendVModel=[[InvitefriendViewModel alloc]init];
    }
    return _friendVModel;
}

- (IBAction)investPeopleBtn:(id)sender {
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

- (IBAction)clickruleBtn:(id)sender {
    InvitePeopleRuleWebVC *invitePeoVC=[[InvitePeopleRuleWebVC alloc]initWithWebPath:@"http://www.mixiaobei.com/mobile/invite.html"];
    [self.navigationController pushViewController:invitePeoVC animated:YES];
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
