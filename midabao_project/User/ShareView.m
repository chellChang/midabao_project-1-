//
//  ShareView.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/21.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ShareView.h"
#import "MidabaoApplication.h"
#import "WXApi.h"
@interface ShareView()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *peopleCircleBtn;
@property (weak, nonatomic) IBOutlet UIButton *WXBtn;
@property (weak, nonatomic) IBOutlet UIButton *DXBtn;
@property (copy,nonatomic)NSString *url;
@property (copy,nonatomic)NSString *title;
@property (copy, nonatomic)NSString *sharedescription;
@property (strong,nonatomic)NSData *shareImgData;


@end
@implementation ShareView
+(instancetype)sharedWechatViewWithURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbImagePath:(NSString *)thumbImagePath{
    ShareView *share=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ShareView class]) owner:nil options:nil]firstObject];
    if ([share isMemberOfClass:[self class]]) {
        [share.peopleCircleBtn addTarget:share action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [share.WXBtn addTarget:share action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [share.DXBtn addTarget:share action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        share.url=url;
        share.title=title;
        share.sharedescription=description;
        UIImage *image=[UIImage imageNamed:@"shareIcon"];
        share.shareImgData = UIImageJPEGRepresentation(image, 0.7);
//        [self loadImageWithImagePath:thumbImagePath complete:^(UIImage *image) {
//            share.shareImgData = UIImageJPEGRepresentation(image, 0.1);
//        }];
        return share;

    }
    return nil;
}
+ (void)loadImageWithImagePath:(NSString *)imagePath complete:(void(^)(UIImage *image))complete {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[MidabaoApplication shareMidabaoApplication] pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]]]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
            [imageData writeToFile:[[MidabaoApplication shareMidabaoApplication] pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]] atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete([UIImage imageWithData:imageData]);
            });
            NSLog(@"%@", imageData ? @"有图片" : @"无图片");
        });
    } else {
        NSData *imageData = [NSData dataWithContentsOfFile:[[MidabaoApplication shareMidabaoApplication] pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]]];
        !complete ? : complete([UIImage imageWithData:imageData]);
    }
}
-(BOOL)canShared {
    
    return [WXApi isWXAppInstalled];
}
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = RGBA(0x000000, 0.15);
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.backgroundColor = [UIColor clearColor];
    } completion:nil];
}
- (IBAction)clickShare:(id)sender {
    if ([self canShared]) {
        UIButton *senderBtn=sender;
        if (senderBtn.tag!=662) {
            WXWebpageObject *webObject = [WXWebpageObject object];
            webObject.webpageUrl = self.url;
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.title;
            message.description = self.sharedescription;
//            [message setThumbImage:[UIImage imageNamed:@"shareIcon.png"]];
            message.thumbData=self.shareImgData;
//            message.thumbData = self.shareImgData;
//            [message setThumbImage:[UIImage imageWithData:self.shareImgData]];
//            [message setThumbData:self.shareImgData];
            message.mediaObject = webObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.message = message;
            req.scene = 660 == senderBtn.tag ? WXSceneTimeline:WXSceneSession;
            [WXApi sendReq:req];
        }else{
            !self.selectShareBlock?:self.selectShareBlock(YES);
        }

    }else{
        !self.selectShareBlock?:self.selectShareBlock(NO);
    }
    [self hideViewWithAnimation:NO];
    
}

- (void)showInWindow:(UIWindow *)window {
    if (!self.superview) {
        self.frame=window.bounds;
        self.showView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 196);
        [window addSubview:self];
        self.frame = window.bounds;
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.showView.frame=CGRectMake(0, self.frame.size.height-196, self.frame.size.width, 196);
        }];
        
    }
}



- (IBAction)ClockBtn:(UIButton *)sender {
    [self hideViewWithAnimation:YES];
}
-(void)hideViewWithAnimation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:Normal_Animation_Duration animations:^{
            self.showView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 196);
        } completion:^(BOOL finished) {
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
    }else{
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
