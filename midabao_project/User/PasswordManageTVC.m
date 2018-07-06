//
//  PasswordManageTVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/16.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "PasswordManageTVC.h"
#import "SetGesturePwdVC.h"
#import "SetGesturePwdVC.h"
#import "ChangeLoginPwdVC.h"
#import "ChangetransactionVC.h"
#import "UserInfoManager.h"
#import "GuideSetexchangePwdVC.h"
#import "userTVCell.h"
@interface PasswordManageTVC ()
@property (weak, nonatomic) IBOutlet UISwitch *gestureState;
@property (weak, nonatomic) IBOutlet UISwitch *touchIdState;

@end

@implementation PasswordManageTVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.gestureState setOn:[[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_GESTURE]];
    [self.touchIdState setOn:[[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_TOUCHID]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    self.tableView.allowsMultipleSelection=YES;
    
}
-(void)setTableView:(UITableView *)tableView{
    self.tableView=tableView;
    self.tableView.allowsMultipleSelection=YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([userTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([userTVCell class])];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (1 == section) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_GESTURE]) {
            
            LAContext *context = [[LAContext alloc] init];
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
                return [super tableView:tableView numberOfRowsInSection:section];
            } else {
                return 2;//无touch id
            }
        } else {
            return 1;//无修改手势密码选项和touch id
        }
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

//打开TouchID

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1&&indexPath.row==1) {//修改手势密码
        SetGesturePwdVC *pwdVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SetGesturePwdVC class])];
        pwdVc.type=kGesturePasswordAlter;
        [pwdVc setCompletionBlock:^(SetGesturePwdVC *vc, GesturePasswordOperationType type) {
            if (kGesturePasswordOperationSuccess == type) {
                
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setBool:YES forKey:DID_OPEN_GESTURE];
//                [userDefaults synchronize];//存储本地手势
//                if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]&&![[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_TOUCHID]) {
//                    
//                    [AlertViewManager showInViewController:self title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//                        if (buttonIndex==1) {//开启指纹解锁
//                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                            [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
//                            [userDefaults synchronize];
//                        }
//                        
//                    } cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
//                }
            }
        }];
        [self.navigationController pushViewController:pwdVc animated:YES];
    }else if (indexPath.section==0&&indexPath.row==0){//修改登录密码
        ChangeLoginPwdVC *changeLogin=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ChangeLoginPwdVC class])];
        [self.navigationController pushViewController:changeLogin animated:YES];
    }else if (indexPath.section==0&&indexPath.row==1){//修改交易密码
        if (![UserInfoManager shareUserManager].userInfo.tradePassword){//如果没有设置交易密码的时候先进行设置交易密码
            [AlertViewManager showInViewController:self title:@"温馨提示" message:@"您还设置交易密码，请先设置交易密码！" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    GuideSetexchangePwdVC *pwd=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([GuideSetexchangePwdVC class])];
                    [self.navigationController pushViewController:pwd animated:YES];
                    
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }else{
            ChangetransactionVC *changeTransaction=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ChangetransactionVC class])];
            [self.navigationController pushViewController:changeTransaction animated:YES];
        }
        
    
    }
}

- (IBAction)changeGestureState:(UISwitch *)sender {
    SetGesturePwdVC *pwdVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SetGesturePwdVC class])];
    pwdVc.type = self.gestureState.isOn ? kGesturePasswordSetting : kGesturePasswordAuth;
    [pwdVc setCompletionBlock:^(SetGesturePwdVC *vc, GesturePasswordOperationType type) {
        if (kGesturePasswordOperationSuccess == type) {
            if (!self.gestureState.isOn) {//关闭手势密码的同时也关闭touch ID
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DID_OPEN_TOUCHID];
                 [sender setOn:NO animated:YES];
            }else{
                
                [sender setOn:YES animated:YES];
//                if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]&&![[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_TOUCHID]) {
//                    
//                    [AlertViewManager showInViewController:self title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//                        if (buttonIndex==1) {//开启指纹解锁
//                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                            [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
//                            [userDefaults synchronize];
//                        }
//                    } cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
//                }

            }
            [[NSUserDefaults standardUserDefaults] setBool:self.gestureState.isOn forKey:DID_OPEN_GESTURE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:pwdVc animated:YES];
        
}
-(void)pushViewControllerWithType{
    
}

- (IBAction)changeTouchIdState:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:DID_OPEN_TOUCHID];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
