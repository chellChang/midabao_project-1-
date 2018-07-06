//
//  HomePageVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.

#import "HomePageVController.h"
#import "NetWorkOperation.h"
#import "StateTableView.h"
#import "HomeTopView.h"
#import "HomeProductTVCell.h"
#import "HomePublicityTVCell.h"
#import "FooterTVCell.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "SignVController.h"
#import "ProjectDetailVC.h"
#define KEY @"0b288A2O307O4Cc9"
#import "NSString+ExtendMethod.h"
#import "UserInfoManager.h"
#import "LoginNavigationVController.h"
#import "UIImageView+LoadImage.h"
#import "MJRefresh.h"
#import "ProjectListModel.h"
#import "UILabel+Format.h"
#import "UILabel+Format.h"
#import "InvitefriendVController.h"
#import "WebVC.h"
#import "findListModel.h"
#import "InvitePeopleRuleWebVC.h"
//static CGFloat headerHeight=442;
@interface HomePageVController ()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,HeadviewDelegate>
@property (nonatomic,strong)NetWorkOperation *operation;
@property (nonatomic,strong)UIView *HeaderView;
@property (nonatomic,strong)StateTableView *homeTableview;
@property (nonatomic,strong)NewPagedFlowView *pageFlowView;
@property (nonatomic,strong)NSMutableArray *bannerArr;
@property (nonatomic,strong)HomeTopView *topView;
@property (strong,nonatomic)NSMutableArray *newsprojectArr;
@property (strong,nonatomic)NSMutableArray *recommendArr;
@property (copy , nonatomic)NSString *userCount;//注册人数
@property (copy , nonatomic)NSString *invPrice;//累计成交额
@property (assign,nonatomic)BOOL isshowBottomView;//是否显示底部的注册人数，YES隐藏NO显示
@property (assign,nonatomic)BOOL backgraoundblack;/**<电量条颜色yes是黑色*/

@property (assign,nonatomic)BOOL isnabaralpha;//是否显示导航条透明yes显示
@end

@implementation HomePageVController

//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.isnabaralpha=YES;
    self.topView.AccountTitle.hidden=![UserInfoManager shareUserManager].logined;
    self.topView.seeAccountBtn.hidden=![UserInfoManager shareUserManager].logined;
    self.topView.myMoneyLab.hidden=![UserInfoManager shareUserManager].logined;
    self.topView.guideBtn.hidden=[UserInfoManager shareUserManager].logined;
    self.topView.safeBtn.hidden=[UserInfoManager shareUserManager].logined;
    self.topView.loginBtn.hidden=[UserInfoManager shareUserManager].logined;
    if ([UserInfoManager shareUserManager].logined) {
        self.topView.seeAccountBtn.selected=[UserInfoManager shareUserManager].ishideproperty;
        if ([UserInfoManager shareUserManager].ishideproperty) {
            self.topView.myMoneyLab.text=@"****";
        }else{
            [self.topView.myMoneyLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.totalAssets andSubText:@""];
        }
    }
    [self.pageFlowView startTimer];
    [self.homeTableview.mj_header beginRefreshing];
    if (!self.backgraoundblack) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.operation cancelFetchOperation];
    [self.pageFlowView stopTimer];
    [self.operation cancelFetchOperation];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
    self.isnabaralpha=NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset=scrollView.contentOffset.y;
    CGFloat alpha=1-((200-offset)/200);
    if (self.isnabaralpha) {
        if (alpha>=0&&alpha<=0.2) {
            [self hideNavigationBar];
        }else if(alpha>0.2){
            [self chanageNavigationBarAlpha:alpha];
        }
        if (alpha<=0) {
            self.backgraoundblack=NO;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        }else if(alpha>0.6&&alpha<=1){
            self.backgraoundblack=YES;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationBar];
    self.isshowBottomView=YES;
//    self.additionalSafeAreaInsets=UIEdgeInsetsMake(-20, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=BackgroundColor;
    [self createUI];
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        @weakify(self)
        self.operation=[NetWorkOperation SendRequestWithMethods:@"articlefind" params:@{@"findType":@"3",@"pageIndex":@1,@"pageSize":@(100)} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            if (self.bannerArr.count>0) {
                [self.bannerArr removeAllObjects];
            }
            NSLog(@"--%@",result);
            [result[RESULT_DATA][@"articleList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                findListModel *model=[findListModel yy_modelWithJSON:obj];
                [self.bannerArr addObject:model];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                if (self.bannerArr.count>0) {
                    self.HeaderView.frame=CGRectMake(0, 0, UISCREEN_WIDTH, (UISCREEN_WIDTH-30)*120/343+10+140+UISCREEN_WIDTH*150/375+20);
                    self.pageFlowView.frame=CGRectMake(0, 140+UISCREEN_WIDTH*150/375+15, UISCREEN_WIDTH,(UISCREEN_WIDTH-30)*120/343+10);
                    self.topView.frame=CGRectMake(0, 0, UISCREEN_WIDTH, 140+UISCREEN_WIDTH*150/375);
                    [UIView animateWithDuration:Normal_Animation_Duration animations:^{
                        [self.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [self.pageFlowView reloadData];
                    }];
                }
                
                
            });
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [SpringAlertView showMessage:errorDescription];
        }];
    });
    dispatch_async(dispatch_queue_create(0, 0), ^{
        self.operation=[NetWorkOperation SendRequestWithMethods:@"softUpdate" params:@{@"phoneType":@"1"} success:^(NSURLSessionTask *task, id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新
                if ([result[RESULT_DATA][@"updateVersion"] floatValue]>[CurrentVersion floatValue]) {
                    if([result[RESULT_DATA][@"isforce"]boolValue]){
                        NSString *desStr=result[RESULT_DATA][@"updateDescribe"];
                        desStr =[desStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                        [AlertViewManager showInViewController:self title:[NSString stringWithFormat:@"v%@版本升级",result[RESULT_DATA][@"updateVersion"]] message:desStr clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/mi-xiao-bei/id1291666489?mt=8"]];
                        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        
                    }else{
                        NSString *desStr=result[RESULT_DATA][@"updateDescribe"];
                        desStr =[desStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                        [AlertViewManager showInViewController:self title:[NSString stringWithFormat:@"v%@版本升级",result[RESULT_DATA][@"updateVersion"]] message:desStr clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                            if (buttonIndex==1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/mi-xiao-bei/id1291666489?mt=8"]];
                            }
                        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    }
                }
                
                
            });
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            
        }];
    });
}
-(void)createUI{
    self.HeaderView.frame=CGRectMake(0, 0, UISCREEN_WIDTH, 140+UISCREEN_WIDTH*150/375+10);
//    self.HeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.topView=[[HomeTopView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 140+UISCREEN_WIDTH*150/375)];
    self.topView.backgroundColor=[UIColor clearColor];
    self.topView.delelgate=self;
    [self.HeaderView addSubview:self.topView];
    //可以请求后判断是否有Banner
    self.pageFlowView.frame=CGRectMake(0, 140+UISCREEN_WIDTH*150/375+15, UISCREEN_WIDTH,0);
    [self.HeaderView addSubview:self.pageFlowView];
    self.HeaderView.frame=CGRectMake(0, 0, 375, 140+UISCREEN_WIDTH*150/375+10);
    self.HeaderView.backgroundColor=BackgroundColor;
    self.homeTableview=[[StateTableView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-45) style:UITableViewStyleGrouped];
    self.homeTableview.delegate=self;
    self.homeTableview.dataSource=self;
    self.homeTableview.tableHeaderView=self.HeaderView;
    self.homeTableview.tableFooterView=[[UIView alloc]init];
    self.homeTableview.estimatedRowHeight=140;
    self.homeTableview.sectionFooterHeight=0.1;
    self.homeTableview.sectionHeaderHeight=0.1;
    self.homeTableview.rowHeight=UITableViewAutomaticDimension;
    self.homeTableview.allowsMultipleSelection = YES;
    [self.homeTableview registerNib:[UINib nibWithNibName:NSStringFromClass([HomeProductTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeProductTVCell class])];
    [self.homeTableview registerNib:[UINib nibWithNibName:NSStringFromClass([HomePublicityTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomePublicityTVCell class])];
    [self.homeTableview registerNib:[UINib nibWithNibName:NSStringFromClass([FooterTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FooterTVCell class])];
    self.homeTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.homeTableview];
    @weakify(self)
    self.homeTableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.newsprojectArr removeAllObjects];
        [self.recommendArr removeAllObjects];
        self.operation=[NetWorkOperation SendRequestWithMethods:@"getrecommend" params:nil success:^(NSURLSessionTask *task, id result) {
            self.userCount=[CommonTools convertToStringWithObject:result[RESULT_DATA][@"userCount"]];
            self.invPrice =[CommonTools convertToStringWithObject:result[RESULT_DATA][@"invPrice"]];
            self.isshowBottomView=[[CommonTools convertToStringWithObject:result[RESULT_DATA][@"hide"]] boolValue];
            [result[RESULT_DATA][@"xsList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ProjectListModel *model=[ProjectListModel yy_modelWithJSON:obj];
                [self.newsprojectArr addObject:model];
            }];
            [result[RESULT_DATA][@"tjList"]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ProjectListModel *model=[ProjectListModel yy_modelWithJSON:obj];
                [self.recommendArr addObject:model];
            }];
            [self.homeTableview.mj_header endRefreshing];
            [self.homeTableview reloadData];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            [self.homeTableview.mj_header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
        
    }];
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(UISCREEN_WIDTH-20,(UISCREEN_WIDTH-30)*120/343+10);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    if (self.bannerArr.count>0) {
        findListModel *model=self.bannerArr[subIndex];
        if (model.isButton==1) {//需要按钮
            InvitePeopleRuleWebVC *invitePeoVC=[[InvitePeopleRuleWebVC alloc]initWithWebPath:model.url];
            [self.navigationController pushViewController:invitePeoVC animated:YES];
        }else{
            WebVC *web=[[WebVC alloc] initWithWebPath:model.url];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
       
    }
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.bannerArr.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView=[[PGIndexBannerSubiew alloc]initWithFrame:CGRectMake(0, 5, UISCREEN_WIDTH-30, (UISCREEN_WIDTH-30)*120/343)];
        bannerView.mainImageView.layer.cornerRadius = 4;
        bannerView.mainImageView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
//      [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    findListModel *model=self.bannerArr[index];
    [bannerView.mainImageView loadbnnerImageWithPath:model.images];
//    bannerView.mainImageView.image = self.bannerArr[index];
    bannerView.layer.shadowColor = [UIColor blackColor].CGColor;
    bannerView.layer.shadowOffset = CGSizeMake(0, 3);
    bannerView.layer.shadowRadius = 4;
    bannerView.layer.shadowOpacity = 0.3;
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark --tableview的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        return self.isshowBottomView?4:5;
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        return self.isshowBottomView?3:4;
    }
    return self.isshowBottomView?2:3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (0==section) {
            return self.newsprojectArr.count;
        }else if (1==section){
            return self.recommendArr.count;
        }
        return 1;
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (0==section) {
            if (self.newsprojectArr.count>0) {
                return self.newsprojectArr.count;
            }else if(self.recommendArr.count>0){
                return self.recommendArr.count;
            }
        }
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (self.isshowBottomView) {//隐藏
            if (indexPath.section==2||indexPath.section==3) {
                return UISCREEN_WIDTH*100/375;
            }
            return UITableViewAutomaticDimension;
        }else{//显示
            if (indexPath.section==2||indexPath.section==3) {
                 return UISCREEN_WIDTH*100/375;
            }else if (indexPath.section==4){
                return 68;
            }
            return UITableViewAutomaticDimension;
        }
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (self.isshowBottomView) {//隐藏
            if (indexPath.section==1||indexPath.section==2) {
                return UISCREEN_WIDTH*100/375;
            }
            return UITableViewAutomaticDimension;
        }else{//显示
            if (indexPath.section==1||indexPath.section==2) {
                return UISCREEN_WIDTH*100/375;
            }else if (indexPath.section==3){
                return 68;
            }
            return UITableViewAutomaticDimension;
        }
    }else{
        if (self.isshowBottomView) {//隐藏
            if (indexPath.section==0||indexPath.section==1) {
                return UISCREEN_WIDTH*100/375;
            }
        }else{//显示
            if (indexPath.section==0||indexPath.section==1) {
                return UISCREEN_WIDTH*100/375;
            }else if (indexPath.section==2){
                return 68;
            }
        }
    }
    return 0;
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (section==3&&self.isshowBottomView) {
            return 20;
        }
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (section==2&&self.isshowBottomView) {
            return 20;
        }
    }else if (section==1&&self.isshowBottomView){
        return 20;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (section==0) {
            return 48;
        }else if (section==1) {
            return 58;
        }
        return 10;
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (section==0) {
            return 48;
        }
        return 10;
    }else{
        if (section!=0) {
            return 10;
        }
        return 0.1;
    
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if(section==0){
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 48)];
            view.backgroundColor=[UIColor whiteColor];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, UISCREEN_WIDTH-32, 48)];
            lable.text=@"新手专享";
            lable.font=[UIFont boldSystemFontOfSize:16];
            lable.textAlignment=NSTextAlignmentLeft;
            lable.textColor=RGB(0x333333);
            [view addSubview:lable];
            UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
            lineImg.image=[UIImage imageNamed:@"lineX_e5"];
            [view addSubview:lineImg];
            return view;
            
            
        }
        if (section==1) {
            UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 58)];
            backView.backgroundColor=[UIColor clearColor];
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, UISCREEN_WIDTH, 48)];
            view.backgroundColor=[UIColor whiteColor];
            [backView addSubview:view];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, UISCREEN_WIDTH-32, 48)];
            lable.text=@"为你推荐";
            lable.font=[UIFont boldSystemFontOfSize:16];
            lable.textAlignment=NSTextAlignmentLeft;
            lable.textColor=RGB(0x333333);
            [view addSubview:lable];
            UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
            lineImg.image=[UIImage imageNamed:@"lineX_e5"];
            [view addSubview:lineImg];
            return backView;
            
        }
    }else if (self.newsprojectArr.count>0){
        if(section==0){
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 48)];
            view.backgroundColor=[UIColor whiteColor];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, UISCREEN_WIDTH-32, 48)];
            lable.text=@"新手专享";
            lable.font=[UIFont boldSystemFontOfSize:16];
            lable.textAlignment=NSTextAlignmentLeft;
            lable.textColor=RGB(0x333333);
            [view addSubview:lable];
            UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
            lineImg.image=[UIImage imageNamed:@"lineX_e5"];
            [view addSubview:lineImg];
            return view;
            
            
        }
    }else if (self.recommendArr.count>0){
        if (section==0) {
            UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 48)];
            backView.backgroundColor=[UIColor clearColor];
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 48)];
            view.backgroundColor=[UIColor whiteColor];
            [backView addSubview:view];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, UISCREEN_WIDTH-32, 48)];
            lable.text=@"为你推荐";
            lable.font=[UIFont boldSystemFontOfSize:16];
            lable.textAlignment=NSTextAlignmentLeft;
            lable.textColor=RGB(0x333333);
            [view addSubview:lable];
            UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 47, UISCREEN_WIDTH, 1)];
            lineImg.image=[UIImage imageNamed:@"lineX_e5"];
            [view addSubview:lineImg];
            return backView;
            
        }
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (self.isshowBottomView) {
            if (indexPath.section==2||indexPath.section==3) {
                HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
                cell.showImg.image=indexPath.section==2?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
                
                return cell;
            }
            HomeProductTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductTVCell class])];
            if (indexPath.section==0) {
                [cell configureUiWithData:self.newsprojectArr[indexPath.row]];
                if (indexPath.row==self.newsprojectArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }else{
                    cell.bottomLineView.hidden=NO;
                }
                
            }else if (indexPath.section==1){
                [cell configureUiWithData:self.recommendArr[indexPath.row]];
                if (indexPath.row==self.recommendArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }else{
                    cell.bottomLineView.hidden=NO;
                }
            }
            return cell;
        }else{
            if (indexPath.section==2||indexPath.section==3) {
                HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
                cell.showImg.image=indexPath.section==2?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
                
                return cell;
            }else if (indexPath.section==4){
                FooterTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FooterTVCell class])];
                cell.contentView.backgroundColor=[UIColor clearColor];
                cell.backgroundColor=[UIColor clearColor];
                cell.registNumber.text=[NSString stringWithFormat:@"%@人",self.userCount];
                [cell.jiaoyiMOney formatNumber:self.invPrice andsubText:@"元"];
                return cell;
            }
            HomeProductTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductTVCell class])];
            if (indexPath.section==0) {
                [cell configureUiWithData:self.newsprojectArr[indexPath.row]];
                if (indexPath.row==self.newsprojectArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }
                
            }else if (indexPath.section==1){
                [cell configureUiWithData:self.recommendArr[indexPath.row]];
                if (indexPath.row==self.recommendArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }
            }
            return cell;
        }
       
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (self.isshowBottomView) {
            
            if (indexPath.section==1||indexPath.section==2) {
                HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
                cell.showImg.image=indexPath.section==1?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
                return cell;
            }else{
                HomeProductTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductTVCell class])];
                if (self.newsprojectArr.count>0) {
                    [cell configureUiWithData:self.newsprojectArr[indexPath.row]];
                    if (indexPath.row==self.newsprojectArr.count-1) {
                        cell.bottomLineView.hidden=YES;
                    }
                }else{
                    [cell configureUiWithData:self.recommendArr[indexPath.row]];
                    if (indexPath.row==self.recommendArr.count-1) {
                        cell.bottomLineView.hidden=YES;
                    }
                }
               
                return cell;
            }
            
        }else{
            if (indexPath.section==1||indexPath.section==2) {
                HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
                cell.showImg.image=indexPath.section==1?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
                
                return cell;
            }else if (indexPath.section==3){
                FooterTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FooterTVCell class])];
                cell.contentView.backgroundColor=[UIColor clearColor];
                cell.backgroundColor=[UIColor clearColor];
                cell.registNumber.text=[NSString stringWithFormat:@"%@人",self.userCount];
                [cell.jiaoyiMOney formatNumber:self.invPrice andsubText:@"元"];
                return cell;
            }
            HomeProductTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeProductTVCell class])];
            if (self.newsprojectArr.count>0) {
                [cell configureUiWithData:self.newsprojectArr[indexPath.row]];
                if (indexPath.row==self.newsprojectArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }
            }else{
                [cell configureUiWithData:self.recommendArr[indexPath.row]];
                if (indexPath.row==self.recommendArr.count-1) {
                    cell.bottomLineView.hidden=YES;
                }
            }
            return cell;
        }
    }
    if (self.isshowBottomView) {
            HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
            cell.showImg.image=indexPath.section==0?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
            return cell;
    }else{
        if (indexPath.section==0||indexPath.section==1) {
            HomePublicityTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePublicityTVCell class])];
            cell.showImg.image=indexPath.section==0?[UIImage imageNamed:@"safeguard"]:[UIImage imageNamed:@"newguilds"];
            
            return cell;
        }
        FooterTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FooterTVCell class])];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.registNumber.text=[NSString stringWithFormat:@"%@人",self.userCount];
        [cell.jiaoyiMOney formatNumber:self.invPrice andsubText:@"元"];
        return cell;
    }
    

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.newsprojectArr.count>0&&self.recommendArr.count>0) {
        if (indexPath.section==0||indexPath.section==1) {
            ProjectDetailVC *projectVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ProjectDetailVC class])];
            
            ProjectListModel *model;
            
            if (indexPath.section==0) {
                model=self.newsprojectArr[indexPath.row];
            }else if (indexPath.section==1){
                model=self.recommendArr[indexPath.row];
            }
            projectVc.projectId=model.homeProjectId;
            projectVc.title=model.proTypeName;
            [self.navigationController pushViewController:projectVc animated:YES];
        }else if (indexPath.section==2){//安全保障
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/safe.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }else if (indexPath.section==3){//新手引导
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/guide.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
    }else if (self.newsprojectArr.count>0||self.recommendArr.count>0){
        if (indexPath.section==0) {
            ProjectDetailVC *projectVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([ProjectDetailVC class])];
            ProjectListModel *model;
            
            if (self.newsprojectArr.count>0) {
                model=self.newsprojectArr[indexPath.row];
            }else if (self.recommendArr.count>0){
                model=self.recommendArr[indexPath.row];
            }
            projectVc.projectId=model.homeProjectId;
            projectVc.title=model.proTypeName;
            [self.navigationController pushViewController:projectVc animated:YES];
        }else if (indexPath.section==1){
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/safe.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }else if (indexPath.section==2){
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/guide.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }else{
        if (indexPath.section==0) {
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/safe.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }else if (indexPath.section==1){
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/guide.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

#pragma mark --headerview代理
-(void)headerViewClickWithType:(clickType)type{
    switch (type) {
        case siginTody:
        {
            if (![UserInfoManager shareUserManager].logined) {
                [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
                return;
            }
           SignVController *signVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([SignVController class])];
            [self.navigationController pushViewController:signVc animated:YES];
        }
            break;
        case loginOrRegist:
        {
            [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
        }
            break;
        case seeMoney:
        {
           [self.topView.myMoneyLab floatformatNumber:[UserInfoManager shareUserManager].userInfo.totalAssets andSubText:@""];
        }
            break;
        case invitePeople:
        {
            if (![UserInfoManager shareUserManager].logined) {
                [self.tabBarController presentViewController:[LoginNavigationVController loginNavigationController] animated:YES completion:nil];
            }else{
                InvitefriendVController *inviteVc=[[MidabaoApplication shareMidabaoApplication]obtainControllerForMainStoryboardWithID:NSStringFromClass([InvitefriendVController class])];
                [self.navigationController pushViewController:inviteVc animated:YES];
            }
        }
            break;
        case aboutMe:{
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/companyTab.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case securityAssurance:{
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/safe.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case newGuide:{
            WebVC *web=[[WebVC alloc] initWithWebPath:@"http://www.mixiaobei.com/mobile/guide.html"];
            web.needPopAnimation=YES;
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark --getter
-(NSMutableArray *)newsprojectArr{
    if (!_newsprojectArr) {
        _newsprojectArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _newsprojectArr;
}
-(NSMutableArray *)recommendArr{
    if (!_recommendArr) {
        _recommendArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _recommendArr;
}
-(UIView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView=[[UIView alloc]init];
    }
    return _HeaderView;
}
-(NewPagedFlowView *)pageFlowView{
    if (!_pageFlowView) {
        _pageFlowView=[[NewPagedFlowView alloc]init];
        _pageFlowView.backgroundColor=[UIColor clearColor];
        _pageFlowView.delegate=self;
        _pageFlowView.dataSource=self;
        _pageFlowView.minimumPageAlpha=0.1;
        _pageFlowView.minimumPageScale=0.95;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll=YES;
    }
    return _pageFlowView;
}
-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
