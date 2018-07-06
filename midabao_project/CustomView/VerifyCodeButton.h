//
//  AuthCodeButton.h
//  wujin-tourist
//
//  Created by wujin  on 15/7/15.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VERIFY_CODE_TYPE_KEY @"codeType"

@interface VerifyCodeButton : UIButton

- (void)countDown:(NSInteger)count;
@end
