//
//  MidabaoMacro.h
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#ifndef MidabaoMacro_h
#define MidabaoMacro_h
#import <UIKit/UIKit.h>

//是否开启手势密码
#define DID_OPEN_GESTURE   @"open_gesture"
#define DID_OPEN_TOUCHID   @"open_touch_id"
#define QuotesLanguage     @"quoteslanguage"//名言
#define Need_Guide_Page    @"need_open_page"//是否需要引导页
#define VERSION_KEY        @"app_version"
#define APP_GUIDE_PAGE_KEY @"UpdateNeedShowGuidePage"

#define APPSECRETVALUE @"7d80fd6fd8054988824e8941216bf1c5"
//Log日志
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define HostUrl @"http://192.168.0.114:8080/licai-api-web/api/" //测试地址
#define ShareHostUrl @"http://192.168.0.114:8080/"
#define SharesubUrl  @"licai-api-web/mobile/toRegister/"
//#define HostUrl @"http://tfyinyi.com/api/"
//#define HostUrl @"http://192.168.0.120:8080/licai-api-web/api/"
#else
//#define NSLog(...)
#define HostUrl @"http://www.mixiaobei.com/api/"
#define ShareHostUrl @"http://www.mixiaobei.com/"
#define SharesubUrl  @"mobiles/toRegister/"
#endif




// iOS系统版本
#define SYSTEM_VERSION_GREATER_THAN_10_Before SYSTEM_VERSION<10.0
#define SYSTEM_VERSION_GREATER_THAN_10 SYSTEM_VERSION>=10.0
#define SYSTEM_VERSION_GREATER_THAN_9 SYSTEM_VERSION >= 9.0
#define SYSTEM_VERSION_GREATER_THAN_8 SYSTEM_VERSION >= 8.0
#define SYSTEM_VERSION_GREATER_THAN_7 SYSTEM_VERSION >= 7.0
#define SYSTEM_VERSION    [[[UIDevice currentDevice] systemVersion] doubleValue]

// 底部tabbar的阴影透明高度
#define SYS_TABBARSHDOWHEIGHT 4
// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT 20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT 20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT 44
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT 44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT 49
// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
// 根据APP_STATUSBAR_HEIGHT判断是否存在热点栏
#define IS_HOTSPOT_CONNECTED (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
// 无热点栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT (SYS_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在APP_STATUSBAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT (APP_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)

#pragma mark --常量
#define Normal_Animation_Duration 0.25
#define TabbarHeight     57
#define Margin_Big_Distance       20
#define Margin_Small_Distance     5
#define Margin_Normal_Distance    10
#define Min_Font_Size             14
#define Font_Size                 15

#pragma mark - 屏幕尺寸

#define UISCREEN_SCALE  (1.0f/[UIScreen mainScreen].scale)
#define UISCREEN_SIZE   [UIScreen mainScreen].bounds.size
#define UISCREEN_WIDTH  UISCREEN_SIZE.width
#define UISCREEN_HEIGHT UISCREEN_SIZE.height

#define RGBALL(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGBA(color, a)  RGBALL( ((color)>>16) & 0xFF, ((color)>>8) & 0xFF, (color) & 0xFF, a)
#define RGB(color)      RGBA( color, 1.0f)

#define BackgroundColor RGB(0xF2F4F6)
#define Theme_Color     RGB(0xFFFFFF)
#define Font_Light_Gray RGB(0x999999)

#define BtnUnColor RGB(0xAECAF7)

#define BtnColor RGB(0x3379EA)

#define APP_VERSION_KEY @"CFBundleShortVersionString"
//设备信息
#define CurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//当前版本号
#define CurrentPhoneVersion  [[UIDevice currentDevice] systemVersion]//手机系统


//验证码时间
#define AUTHCODE_REPEAT_INTERVAL 60

//验证码类型
#define VERIFY_REGIST @"0"//注册验证码
#define VERIFY_FINDLOGINPWD @"1"//找回登录密码验证码
#define VERIFY_BINDBANK @"2"//绑定银行卡验证码
#define VERIFY_FINDTRAPWD @"5"//找回交易密码验证码

#define VERIFY_CHANGEPHONE @"6"//修改绑定手机号验证码



#endif /* MidabaoMacro_h */
