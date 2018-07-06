//
//  productDetailView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "productDetailView.h"
#import "NSString+ExtendMethod.h"
#import "UILabel+Format.h"
#import "NSString+ExtendMethod.h"
#import "CountDown.h"
static float responseHeight=30;
@interface productDetailView()<UIScrollViewDelegate>
@property (strong, nonatomic)  CountDown *countDownStr;
@property (copy,nonatomic)NSString *dayStr;
@property (copy,nonatomic)NSString *hourStr;
@property (copy,nonatomic)NSString *minuteStr;
@property (copy,nonatomic)NSString *secondStr;
@property (strong,nonatomic)NSDate *entTiem;
@property (assign,nonatomic)NSInteger currentType;
@property (strong,nonatomic)projectDetailModel *projectModel;

@end
@implementation productDetailView
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)rockenTimeWithState:(BOOL)state{
    if (state) {//关闭
        [self.countDownStr destoryTimer];
    }else{
        
        [self startLongLongStartDate:[NSDate date] longlongFinishDate:self.entTiem];
//        if(self.currentType!=5){
//            self.projectRate.textColor=RGB(0x999999);
//            self.extraRate.textColor=RGB(0x999999);
//            self.time.text=@"募集剩余时间：已售罄";
//            self.time.textColor=RGB(0x999999);
//        }
    }
}
-(instancetype)initProductDetailViewWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.scrollview.delegate=self;
        
        self.backgroundColor=RGB(0xF2F4F6);
        self.BottomLab.text=@"松手，加载下一页";
        [self.scrollview addSubview:self.BottomLab];
    }
    return self;
}
-(void)updataUiWithModel:(projectDetailModel *)model{
    self.projectModel=model;
    self.projectName.text=model.proName;
    self.projectRate.text=[NSString stringWithFormat:@"%.1f%%",model.interestRate];
    self.extraRate.hidden=model.addInterestRate?NO:YES;
    self.extraRate.text=model.addInterestRate?[NSString stringWithFormat:@"+%.1f%%",model.addInterestRate]:@"";
    NSString *limtType=model.termCompany==1?@"天":@"个月";
    NSString *limtDay=[NSString stringWithFormat:@"%ld%@",model.term,limtType];
    
    self.limtDay.attributedText=[limtDay changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} Range:NSMakeRange(limtDay.length-limtType.length, limtType.length)];
    NSString *eachStr=[NSString stringWithFormat:@"%ld元",model.eachAmount];
    
    self.eachAmount.attributedText=[eachStr changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} Range:NSMakeRange(eachStr.length-1, 1)];
    NSString *str=[NSString stringWithFormat:@"%.0f", model.votePrice];
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"###,##0"];
    NSString *votepricstr=[NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:votepricstr];
    [string1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:16]} range:NSMakeRange(0,votepricstr.length-1)];
    [string1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:11]} range:NSMakeRange(votepricstr.length-1,1)];
    self.votePrice.attributedText=string1;
    NSString *totalMoney=[NSString stringWithFormat:@"%.0f",model.totalPrice];
    NSString *totalStr=[NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:[totalMoney doubleValue]]]];
    self.totalPrice.attributedText=[totalStr changeAttributeStringWithAttribute:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Regular" size:14]} Range:NSMakeRange(0, totalStr.length)];
    switch (model.mode) {
        case 1:
            self.huankuanType.text=@"一次性还本付息";
            self.huankuanstapeOne.hidden=YES;
            self.huankuansteapTwo.hidden=NO;
            break;
        case 2:
            self.huankuanType.text=@"按月还息，到期还本";
            self.huankuanstapeOne.hidden=NO;
            self.huankuansteapTwo.hidden=YES;
            break;
        case 3:
            self.huankuanType.text=@"等额本息";
            self.huankuanstapeOne.hidden=NO;
            self.huankuansteapTwo.hidden=YES;
            break;
        default:
            self.huankuanType.text=@"等额本息";
            self.huankuanstapeOne.hidden=NO;
            self.huankuansteapTwo.hidden=YES;
            break;
    }
    if (model.projectStatus!=5) {
        self.projectRate.textColor=RGB(0x999999);
        self.extraRate.textColor=RGB(0x999999);
        if (model.projectStatus==7) {
            self.time.text=@"募集剩余时间：已流标";
        }else{
            self.time.text=@"募集剩余时间：已售罄";
        }
        self.time.textColor=RGB(0x999999);
    }
    self.currentType=model.projectStatus;
    self.entTiem=model.entTime;
    [self startLongLongStartDate:[NSDate date] longlongFinishDate:model.entTime];
}
///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartDate:(NSDate *)startDate longlongFinishDate:(NSDate *)finishDate{
    __weak __typeof(self) weakSelf= self;
    if (self.currentType==5) {
        [self.countDownStr countDownWithStratDate:startDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
        }];

    }
}
-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    if (day==0) {
        self.dayStr = @"0";
    }else{
        self.dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    }
    if (hour<10&&hour) {
        self.hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }else{
        self.hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    if (minute<10) {
        self.minuteStr = [NSString stringWithFormat:@"0%ld",(long)minute];
    }else{
        self.minuteStr = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    if (second<10) {
        self.secondStr = [NSString stringWithFormat:@"0%ld",(long)second];
    }else{
        self.secondStr = [NSString stringWithFormat:@"%ld",(long)second];
    }
    if (day>0) {
        NSString *timeStr=[NSString stringWithFormat:@"募集剩余时间: %@天%@小时%@分%@秒",self.dayStr,self.hourStr,self.minuteStr,self.secondStr];
        NSMutableAttributedString *mutString=[[NSMutableAttributedString alloc]initWithString:timeStr];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length-2-self.hourStr.length-1-self.dayStr.length, self.dayStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length-2-self.hourStr.length, self.hourStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length, self.minuteStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length, self.secondStr.length)];
        self.time.attributedText=mutString;
    }else if(hour>0){
        NSString *timeStr=[NSString stringWithFormat:@"募集剩余时间：%@小时%@分%@秒",self.hourStr,self.minuteStr,self.secondStr];
        NSMutableAttributedString *mutString=[[NSMutableAttributedString alloc]initWithString:timeStr];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length-2-self.hourStr.length, self.hourStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length, self.minuteStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length, self.secondStr.length)];
        self.time.attributedText=mutString;
    }else if (minute>0){
        NSString *timeStr=[NSString stringWithFormat:@"募集剩余时间：%@分%@秒",self.minuteStr,self.secondStr];
        NSMutableAttributedString *mutString=[[NSMutableAttributedString alloc]initWithString:timeStr];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length-1-self.minuteStr.length, self.minuteStr.length)];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-1-self.secondStr.length, self.secondStr.length)];
        self.time.attributedText=mutString;
    }else{
        NSString *timeStr=@"募集剩余时间：即将结束";
        NSMutableAttributedString *mutString=[[NSMutableAttributedString alloc]initWithString:timeStr];
        [mutString addAttributes:@{NSForegroundColorAttributeName:RGB(0xFF7F1B)} range:NSMakeRange(timeStr.length-4, 4)];
        self.time.attributedText=mutString;
        if (second==0) {
            //刷新ui
            self.projectModel.projectStatus=7;
            [self updataUiWithModel:self.projectModel];
            !self.refirshCurrentState?:self.refirshCurrentState();
        }
       
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentOffSetY=scrollView.contentOffset.y;
    CGFloat beforeHeight=responseHeight*(-1);
    if (contentOffSetY<beforeHeight) {
        NSLog(@"上一页");
        if ([self.delegate respondsToSelector:@selector(PullDownView:andPullType:)]) {
            [self.delegate PullDownView:self andPullType:pullTypeUp];
        }
        
    }else if (contentOffSetY>(scrollView.contentSize.height-scrollView.bounds.size.height+responseHeight)){
        NSLog(@"下一页");
        if ([self.delegate respondsToSelector:@selector(PullDownView:andPullType:)]) {
            [self.delegate PullDownView:self andPullType:pullTypeDown];
        }
    }
}


-(CountDown *)countDownStr{
    if (!_countDownStr) {
        _countDownStr=[[CountDown alloc]init];
    }
    return _countDownStr;
}
-(UILabel *)BottomLab{
    if (!_BottomLab) {
        if (self.mainViewHeight.constant<UISCREEN_HEIGHT-64-49) {
            _BottomLab=[[UILabel alloc]initWithFrame:CGRectMake(0, UISCREEN_HEIGHT-64-49, self.bounds.size.width, responseHeight)];
        }else{
            _BottomLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.backView.frame.size.height, self.bounds.size.width, responseHeight)];
        }
        _BottomLab.textAlignment=NSTextAlignmentCenter;
        _BottomLab.font=[UIFont systemFontOfSize:14];
        _BottomLab.textColor=RGB(0x666666);
    }
    return _BottomLab;
}
@end
