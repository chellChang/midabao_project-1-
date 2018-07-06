//
//  RealNameInfoVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "RealNameInfoVController.h"
#import "UserInfoManager.h"
@interface RealNameInfoVController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idCard;
@property (strong,nonatomic)NetWorkOperation *operation;

@end

@implementation RealNameInfoVController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self requestData];
    // Do any additional setup after loading the view.
}
-(void)requestData{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.operation=[NetWorkOperation SendRequestWithMethods:@"queryUserInfo" params:@{@"userId":[UserInfoManager shareUserManager].userInfo.userid} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [BaseIndicatorView hide];
        [self getUserInfowithDate:result[RESULT_DATA][@"userInfo"]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
-(void)getUserInfowithDate:(NSDictionary *)dic{
    self.name.text=dic[@"name"];
    self.idCard.text=dic[@"idCard"];
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
