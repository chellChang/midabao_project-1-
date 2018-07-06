//
//  MyCenterVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MyCenterVController.h"
#import "CenterTVCell.h"
#import "PasswordManageTVC.h"
#import "MyBankVController.h"
#import "RealNameInfoVController.h"
#import "UserInfoManager.h"
#import "NSString+ExtendMethod.h"
#import "ChangeMyBindPhoneVC.h"
#import "AddBankVController.h"
#import "GuideSetexchangePwdVC.h"
#import <sys/utsname.h>
@interface MyCenterVController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cneterTabview;

@end

@implementation MyCenterVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
    [self.cneterTabview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    // Do any additional setup after loading the view.
}
#pragma mark tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0==section?4:1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CenterTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CenterTVCell class])];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.titleLab.text=@"绑定手机号";
            cell.subLab.text=[[UserInfoManager shareUserManager].userInfo.mobile hidePosition:kHideStringCenter length:[UserInfoManager shareUserManager].userInfo.mobile.length/2];
            cell.bottomLine.hidden=NO;
        }else if (indexPath.row==1){
            cell.titleLab.text=@"实名认证";
            if (![UserInfoManager shareUserManager].userInfo.certifierstate) {
                cell.subLab.text=@"立即认证";
            }else{
                cell.subLab.text=@"查看";
            }
            cell.bottomLine.hidden=NO;
        }else if (indexPath.row==2){
            cell.titleLab.text=@"我的银行卡";
            cell.subLab.text=@"查看";
            cell.bottomLine.hidden=NO;
        }else if (indexPath.row==3){
            cell.titleLab.text=@"密码管理";
            cell.subLab.text=@"";
            cell.bottomLine.hidden=YES;
        }
    }else if(indexPath.section==1){
        cell.titleLab.text=@"设备版本信息";
        cell.subLab.text=@"查看";
        cell.bottomLine.hidden=YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0&&indexPath.row==0) {//修改绑定手机号
        if (![UserInfoManager shareUserManager].userInfo.certifierstate) {//没有实名认证
            [self goRealNameAndBingBank];
        }else{
            ChangeMyBindPhoneVC *changePhone=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ChangeMyBindPhoneVC class])];
            [self.navigationController pushViewController:changePhone animated:YES];
        }
    }
    if (indexPath.section==0&&indexPath.row==3) {
        PasswordManageTVC *password=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([PasswordManageTVC class])];
        [self.navigationController pushViewController:password animated:YES];
    }else if (indexPath.section==0&&indexPath.row==2){//我的银行卡
        MyBankVController *addbankVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([MyBankVController class])];
        [self.navigationController pushViewController:addbankVc animated:YES];
    }else if (indexPath.section==0&&indexPath.row==1){//实名认证
        if (![UserInfoManager shareUserManager].userInfo.certifierstate) {//没有实名认证
            [self goRealNameAndBingBank];
        }else{
            RealNameInfoVController *realNameVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([RealNameInfoVController class])];
            [self.navigationController pushViewController:realNameVc animated:YES];
        }
        
    }else if (indexPath.section==1){
        [AlertViewManager showInViewController:self title:@"设备信息" message:[NSString stringWithFormat:@"手机机型：%@\n系统版本：%@\nAPP版本：%@",[self iphoneType],CurrentPhoneVersion,CurrentVersion] clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string=[NSString stringWithFormat:@"手机机型：%@\n系统版本：%@\nAPP版本：%@",[self iphoneType],CurrentPhoneVersion,CurrentVersion];
                [SpringAlertView showMessage:@"已复制粘贴板，请去粘贴"];
            }
        } cancelButtonTitle:@"复制" otherButtonTitles:@"确定", nil];
    }
    
}
-(void)goRealNameAndBingBank{
    [AlertViewManager showInViewController:self title:@"温馨提示" message:@"您还未实名认证，请先绑定银行卡进行实名认证" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            if (![UserInfoManager shareUserManager].userInfo.tradePassword) {//如果没有设置交易密码的时候先进行设置交易密码
                GuideSetexchangePwdVC *pwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetexchangePwdVC class])];
                [self.navigationController pushViewController:pwd animated:YES];
            }else{
                AddBankVController *addBank=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([AddBankVController class])];
                [self.navigationController pushViewController:addBank animated:YES];
            }
          
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}
-(void)setCneterTabview:(UITableView *)cneterTabview{
    _cneterTabview=cneterTabview;
    _cneterTabview.delegate=self;
    _cneterTabview.dataSource=self;
    _cneterTabview.allowsMultipleSelection=YES;
}
#pragma mark --退出登录
- (IBAction)quitClick:(id)sender {
    if ([UserInfoManager shareUserManager].logined) {
        [AlertViewManager showInViewController:self title:@"温馨提示" message:@"是否退出登录？" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UserInfoManager shareUserManager]logout];//清除登录信息
                [SpringAlertView showMessage:@"退出登录成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
   
}
- (NSString *)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])
        return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])
        return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])
        return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])
        return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])
        return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])
        return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])
        return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])
        return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    
    return platform;
    
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
