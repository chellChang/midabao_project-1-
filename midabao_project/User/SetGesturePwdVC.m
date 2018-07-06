//
//  SetGesturePwdVC.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/17.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "SetGesturePwdVC.h"
#import "GesturePassword.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TCKeychain.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UserInfoManager.h"
#define ALTER_GESTURE_PASSWORD  @"修改手势密码"
#define AUTH_GESTURE_PASSWORD   @"验证手势密码"
#define SETUP_GESTURE_PASSWORD  @"设置手势密码"
#define LOGIN_GESTURE_PASSWORD  @"登录手势密码"

#define BE_CAREFUL              @"绘制密码时，谨防他人偷看"
#define DRAW_AGAIN              @"重新绘制"

#define OLD_INPUT               @"请绘制原手势密码进行验证"
#define INPUT                   @"请绘制新手势密码"
#define INPUT_AGAIN             @"请再次绘制手势密码"

#define AUTO_NOTE               @"请绘制手势密码进行验证"

#define START_NOTE              @"请绘制屏幕图案，至少连接4个点"

#define ERROR_NOT_ENOUGH        @"请至少连接四个点"
#define ERROE_NOT_SAME          @"两次绘制不一致，请重新绘制"
#define ERROR_INPUT             @"密码错误"

#define SUCCESS                 @"验证成功"
#define MORE_ERROR_INFO         @"手势错误，您还可以输入%@次"

@interface SetGesturePwdVC ()

@property (copy, nonatomic) void(^callBack)(SetGesturePwdVC *, GesturePasswordOperationType);

@property (assign, nonatomic) NSInteger maxErrorCount;
@property (assign, nonatomic) BOOL      isCancel;
@property (strong, nonatomic) NSString  *password;

@property (assign ,nonatomic) NSInteger bottomType;/**<1.重新绘制2.忘记手势密码*/

@property (weak, nonatomic) IBOutlet UILabel *userInfoLab;
@property (weak, nonatomic) IBOutlet UIView *topInfoView;
@property (weak, nonatomic) IBOutlet GesturePassword *gesturePassword;
@property (weak, nonatomic) IBOutlet UIView *lineY;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *touchIdBtn;
@property (weak, nonatomic) IBOutlet UIButton *drawAgainButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *xinqiLab;
@property (weak, nonatomic) IBOutlet UILabel *celebratedDictumLab;

@end

@implementation SetGesturePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCancel      = YES;
    self.type          = _type;
    self.maxErrorCount = 5;
    if (self.type!=kGesturePasswordLogin) {
        [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
            [viewController.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    self.xinqiLab.text=[self getCurrentWeekDay];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"MM.dd"];
    NSString *daystr=[dateFormat stringFromDate:[NSDate date]];
    self.dayLab.text=[[daystr componentsSeparatedByString:@"."] lastObject];
    self.monthLab.text=[self getcurrrentMonthWith:[[[daystr componentsSeparatedByString:@","] firstObject] integerValue]];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *langestr=[[NSUserDefaults standardUserDefaults]valueForKey:QuotesLanguage];
    if (![langestr isEqualToString:@""]&&langestr!=nil&&![langestr isKindOfClass:[NSNull class]]) {
        self.celebratedDictumLab.text=langestr;
    }
    // Do any additional setup after loading the view.
}
//获取当前月份
-(NSString *)getcurrrentMonthWith:(NSInteger )month{
    NSArray*monthArr = [NSArray arrayWithObjects: [NSNull null],@"Jan.",@"Feb.",@"Mar.",@"Apr.",@"May.",@"Jun.",@"Jul.",@"Aug.",@"Sep.",@"Oct.",@"Nov.",@"Dec.",nil];
    return [monthArr objectAtIndex:month];
    
}
// 获取当前是星期几
- (NSString*)getCurrentWeekDay

{
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    
    return[weekdays objectAtIndex:theComponents.weekday];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self.navigationController.navigationBar setCustomShadowColor:[UIColor whiteColor]];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isCancel && self.callBack) {
        @weakify(self)
        self.callBack(self_weak_, kGesturePasswordOperationCancel);
    }
}
#pragma mark - publick
-(void)setCompletionBlock:(void (^)(SetGesturePwdVC *, GesturePasswordOperationType))callBack{
    self.callBack = callBack;
}

#pragma mark - private method

- (void)gestureDidFailure {
    
    NSString *errInfo = nil;
    if (kGesturePasswordSetting != self.type) {
        
        self.maxErrorCount--;
        
        NSString *moreInfo = [NSString stringWithFormat:MORE_ERROR_INFO, @(self.maxErrorCount)];
//        errInfo = [NSString stringWithFormat:@"%@,%@",ERROR_NOT_ENOUGH, moreInfo];
        errInfo=moreInfo;
    } else {
        errInfo = ERROR_NOT_ENOUGH;//如果是设置手势密码的时候
    }
    
    [self setErrorSpring:errInfo];
}
- (void)gestureDidSuccess:(NSString *)password {
    
    if (kGesturePasswordSetting == self.type) {//设置手势密码
        if (self.password.length) {//验证第二次设置的和第一次设置的是否相同
            
            if ([password isEqualToString:self.password]) { //设置手势成功
                
                self.userInfoLab.text = SUCCESS;
                self.userInfoLab.textColor=RGB(0x3379EA);
                NSMutableDictionary *userNamePassPairs = [TCKeychain load:KEY_USER_INFO];
                [userNamePassPairs setValue:self.password forKey:KEY_USER_GESTUREPASSWORD];
                [TCKeychain save:KEY_USER_INFO data:userNamePassPairs];
                
                @weakify(self)
                if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationSuccess);
                
                self.isCancel = NO;
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self setErrorSpring:ERROE_NOT_SAME];
            }
        } else {//第二次设置的时候
            
            NSMutableArray *hightPoints = [[NSMutableArray alloc] init];
            for (NSString *part in [password componentsSeparatedByString:@"-"]) {
                [hightPoints addObject:@([self.gesturePassword.values indexOfObject:part])];
            }            
            [self.drawAgainButton setTitle:DRAW_AGAIN forState:UIControlStateNormal];
            self.bottomType=1;
            self.drawAgainButton.userInteractionEnabled = YES;
            self.userInfoLab.text                       = INPUT_AGAIN;
            self.userInfoLab.textColor=RGB(0x3379EA);
            self.password                               = password;
            [self updateTopviewImgWithPassword:self.password];
        }
    } else {//验证手势密码
        
        NSDictionary *userinfo    = [TCKeychain load:KEY_USER_INFO];
        NSString *gesturePassword = userinfo[KEY_USER_GESTUREPASSWORD];
        
        if ([gesturePassword isEqualToString:password]) {//验证手势成功
            
            [self authGestureSuccess];//后续操作
        } else {
            self.maxErrorCount--;
            NSString *moreInfo = [NSString stringWithFormat:MORE_ERROR_INFO, @(self.maxErrorCount)];
//            NSString *errInfo  = [NSString stringWithFormat:@"%@, %@", ERROR_INPUT, moreInfo];
            NSString *errInfo=moreInfo;
            [self setErrorSpring:errInfo];
        }
    }
}
#pragma mark --更新绘制颜色
-(void)updateTopviewImgWithPassword:(NSString *)pwd{
    NSArray *arr=self.topInfoView.subviews;
    NSArray *pwdArr=[pwd componentsSeparatedByString:@"-"];
    if (self.password.length) {//变色
        for (NSString *indexstr in pwdArr) {
            NSInteger index=[indexstr integerValue];
            UIImageView *img=[self.topInfoView viewWithTag:600+index];
            img.image=[UIImage imageNamed:@"tapselectxiaoIcon"];
        }
        
    }else{//不变
        for (UIImageView *img in arr) {
            img.image=[UIImage imageNamed:@"tapunxiaoIcon"];
        }
    }
}
- (void)authGestureSuccess {
    
    if (kGesturePasswordAlter == self.type) {//修改手势密码
        self.userInfoLab.text = START_NOTE;
        self.userInfoLab.textColor=RGB(0x3379EA);
        self.type             = kGesturePasswordSetting;//判断会不会走setType;
    } else {
        self.userInfoLab.text = SUCCESS;
        self.userInfoLab.textColor=RGB(0x3379EA);
        self.isCancel = NO;
        
        @weakify(self)
        if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationSuccess);
        if (self.navigationController) [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setErrorSpring:(NSString *)errInfo{
    
    self.userInfoLab.text = errInfo;
    self.userInfoLab.textColor=RGB(0xFF2C2C);
    CGPoint position = self.userInfoLab.layer.position;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[
                         [NSValue valueWithCGPoint:position],
                         [NSValue valueWithCGPoint:CGPointMake(position.x + 2*Margin_Small_Distance, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - 2*Margin_Small_Distance, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x + Margin_Big_Distance, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - Margin_Big_Distance, position.y)],
                         [NSValue valueWithCGPoint:position]
                         ];
    
    animation.duration            = 1.0f;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;
    
    [self.userInfoLab.layer addAnimation:animation forKey:@"errAnimation"];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
- (IBAction)forgetClick:(id)sender {
    [[UserInfoManager shareUserManager] logout];//执行退出登录操作
    NSLog(@"执行退出登录操作");
    @weakify(self)
    if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationLogout);
    self.isCancel      = NO;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)authTouchIdClick:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle=@"";
    if ([userDefaults boolForKey:DID_OPEN_TOUCHID] & [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self authGestureSuccess];
                });
            }
        }];
    }
    
}
- (IBAction)drawAgainClick:(UIButton *)sender {
    if (self.bottomType==1) {//重新绘制
        self.password         = @"";
        [self updateTopviewImgWithPassword:self.password];
        self.userInfoLab.text = START_NOTE;
        self.userInfoLab.textColor=RGB(0x3379EA);
        [self.drawAgainButton setTitle:BE_CAREFUL forState:UIControlStateNormal];
        self.drawAgainButton.userInteractionEnabled=NO;
    }else if (self.bottomType==2){//忘记手势密码
        [self forgetClick:nil];
    }
    
    
}


#pragma mark - setter & getter
- (void)setGesturePassword:(GesturePassword *)gesturePassword {
    _gesturePassword = gesturePassword;
    
    gesturePassword.separatedString   = @"-";
    gesturePassword.minPasswordLength = 4;
    //设置手势密码回调
    @weakify(self)
    [gesturePassword setCompletionBlock:^( NSString *password, GestureCompletionType type) {
        @strongify(self)
        
        [self.gesturePassword clear];//清楚手势密码
        
        if (kGestureCompletionSuccess == type) {
            [self gestureDidSuccess:password];//成功
        } else if (kGestureCompletionNotEnough == type) {
            [self gestureDidFailure];//失败
        }
    }];
}
- (void)setType:(GesturePasswordVCType)type {
    _type = type;
    if (kGesturePasswordAlter == self.type) { //修改手势密码
        self.userInfoLab.text = OLD_INPUT;
        self.userInfoLab.textColor=RGB(0x3379EA);
        self.topInfoView.hidden=YES;
        self.logoImg.hidden=YES;
        self.drawAgainButton.hidden=NO;
        self.lineY.hidden=YES;
        self.forgetBtn.hidden=YES;
        self.touchIdBtn.hidden=YES;
        self.drawAgainButton.userInteractionEnabled=YES;
        self.bottomType=2;
        [self.drawAgainButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    } else if (kGesturePasswordAuth == self.type) { //验证手势密码
        self.userInfoLab.text=AUTO_NOTE;
        self.userInfoLab.textColor=RGB(0x3379EA);
        self.topInfoView.hidden=YES;
        self.logoImg.hidden=YES;
        self.drawAgainButton.hidden=NO;
        self.lineY.hidden=YES;
        self.forgetBtn.hidden=YES;
        self.touchIdBtn.hidden=YES;
        self.drawAgainButton.userInteractionEnabled=YES;
        self.bottomType=2;
        [self.drawAgainButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    } else if(kGesturePasswordSetting==self.type) {//设置手势密码的时候
        self.topInfoView.hidden=NO;
        self.logoImg.hidden=YES;
        self.userInfoLab.text = START_NOTE;
        self.userInfoLab.textColor=RGB(0x3379EA);
        self.lineY.hidden=YES;
        self.forgetBtn.hidden=YES;
        self.touchIdBtn.hidden=YES;
        self.drawAgainButton.hidden=NO;
        [self.drawAgainButton setTitle:BE_CAREFUL forState:UIControlStateNormal];
        self.drawAgainButton.userInteractionEnabled=NO;
    }else{//登录手势密码
        self.userInfoLab.text=@"";
        self.logoImg.hidden=NO;
        self.topInfoView.hidden=YES;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:DID_OPEN_TOUCHID]&&[[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {//开启指纹的时候
            self.drawAgainButton.hidden=YES;
            self.lineY.hidden=NO;
            self.forgetBtn.hidden=NO;
            self.touchIdBtn.hidden=NO;
        }else{//没有开启指纹的时候
            self.drawAgainButton.hidden=NO;
            self.lineY.hidden=YES;
            self.forgetBtn.hidden=YES;
            self.touchIdBtn.hidden=YES;
            self.drawAgainButton.userInteractionEnabled=YES;
            self.bottomType=2;
            [self.drawAgainButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        }
    }
}
- (void)setMaxErrorCount:(NSInteger)maxErrorCount {
    
    _maxErrorCount = maxErrorCount;
    
    if (maxErrorCount <= 0) {
        [self forgetClick:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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
