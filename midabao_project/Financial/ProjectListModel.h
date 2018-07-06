//
//  ProjectListModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/8/25.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectListModel : NSObject
@property (assign ,nonatomic)NSInteger proType;/**<1赎楼 2房产信用贷 3消费信用贷*/
@property (copy ,nonatomic)NSString *proName;/**<项目名称*/
@property (assign ,nonatomic)CGFloat interestRate;/**<利率*/
@property (assign ,nonatomic)CGFloat addInterestRate;/**<加息利率*/
@property (assign ,nonatomic)NSInteger term;/**<项目期限*/
@property (assign ,nonatomic)NSInteger termCompany;/**<期限单位 1 天 2 月*/
@property (assign ,nonatomic)NSInteger projectStatus;/**< 5 募集中（6已满标,8待回款,9已结清,10回款逾期）=已售罄*/
@property (assign ,nonatomic)CGFloat votePrice;/**<剩余金额*/
@property (copy ,nonatomic)NSString *projectId;
@property (copy , nonatomic)NSString *homeProjectId;
@property (copy ,nonatomic)NSString *proTypeName;/**<项目类型*/
@end
