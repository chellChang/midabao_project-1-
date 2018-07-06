//
//  projectDetailModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/28.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface projectDetailModel : NSObject
@property (assign,nonatomic)NSInteger proType;/**<1赎楼 2房产信用贷 3消费信用贷'*/
@property (copy,nonatomic)NSString *proName;
@property (assign,nonatomic)CGFloat interestRate;
@property (assign,nonatomic)CGFloat addInterestRate;
@property (assign,nonatomic)NSInteger term;
@property (assign,nonatomic)NSInteger termCompany;/**<期限单位 1 天 2 月*/
@property (assign,nonatomic)NSInteger projectStatus;/**<5 募集中  （6已满标  8待回款 9已结清 10 回款逾期 ）=已售罄*/
@property (assign,nonatomic)NSInteger eachAmount;
@property (assign,nonatomic)CGFloat votePrice;
@property (strong,nonatomic)NSDate *startTime;
@property (strong,nonatomic)NSDate *entTime;

@property (assign,nonatomic)CGFloat totalPrice;
@property (assign,nonatomic)NSInteger mode;/**<'回款方式 1一次性还本付息 2按月还息，到期还本 3 等额本息'*/
@property (copy,nonatomic)NSString *dayProfit;
@property (copy,nonatomic)NSString *extend;
@property (copy,nonatomic)NSArray  *extend_data;
@property (copy,nonatomic)NSArray *imags;
@property (copy,nonatomic)NSArray *sttrData;
@property (copy,nonatomic)NSString  *productId;/**<产品id*/
@property (strong,nonatomic)NSArray *borrowerList;//借款人信息集合
@property (strong,nonatomic)NSArray *investmentRankingList;//用户投资排行
@property (copy,nonatomic)NSString  *projectId;/**<项目ID*/
@property (copy,nonatomic)NSString  *proTypeName;/**<项目类型*/
@end
