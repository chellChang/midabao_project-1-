//
//  myinvestlistModel.h
//  midabao_project
//
//  Created by 杨路 on 2017/9/7.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myinvestlistModel : NSObject
@property (copy , nonatomic)NSString *proName;
@property (assign,nonatomic)CGFloat interestRate;
@property (assign,nonatomic)CGFloat addInterestRate;
@property (assign,nonatomic)NSInteger term;
@property (assign,nonatomic)NSInteger termCompany;
@property (assign,nonatomic)NSInteger projectStatus;/**<项目状态 5 募集中 6已满标  7已流标 8待回款 9已结清 10 回款逾期*/
@property (strong,nonatomic)NSDate *entTime;//结束时间
@property (strong,nonatomic)NSDate *settleTime;//结清时间
@property (strong,nonatomic)NSDate *lossTime;//流标时间
@property (strong,nonatomic)NSDate *invTime;//投资时间
@property (copy,nonatomic)NSString *residuedays;//剩余时间
@property (strong,nonatomic)NSDate *repTime;//回款中的时候到期时间
@property (copy , nonatomic)NSString *repDays;//回款中的时候剩余天数
@property (copy , nonatomic)NSString *projectId;
@property (assign,nonatomic)CGFloat invPrice;
@end
