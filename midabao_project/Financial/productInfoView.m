//
//  productInfoView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/8.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "productInfoView.h"

#import "projectDecView.h"
#import "projectDetailModel.h"
#import "QuestView.h"
#import "InvestmentView.h"
static float responseHeight=30;
@interface productInfoView()<UIScrollViewDelegate,projectDetialDelegate,QuestViewDelegate,InvestmentDelelgte>
@property (weak, nonatomic) IBOutlet UIView *Topsuperview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;
@property (strong,nonatomic)UILabel *headerLab;
@property (strong,nonatomic)projectDecView *proDetailView;
@property (strong,nonatomic)projectDecView *profkView;
@property (strong,nonatomic)QuestView *prowtView;
@property (strong,nonatomic)InvestmentView *investmentView;
@property (strong,nonatomic)projectDetailModel *projectModel;
@property (assign,nonatomic)NSInteger currenttype;
@end
@implementation productInfoView
-(instancetype)initProductInfoViewWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
        self.frame=frame;
        self.backScrollview.delegate=self;
        self.contentScrollview.delegate=self;
        self.backgroundColor=RGB(0xF2F4F6);
        self.headerLab.text=@"松手，返回上一页";
        self.currenttype=1;
        [self.backScrollview addSubview:self.headerLab];
        [self crateUI];
    }
    return self;
}


-(void)crateUI{
    self.proDetailView.delegate=self;
    self.proDetailView.bankScroll=self.backScrollview;
    self.profkView.bankScroll=self.backScrollview;
    self.profkView.delegate=self;
    self.prowtView.delegate=self;
    self.prowtView.bankScroll=self.backScrollview;
    self.investmentView.delegate=self;
    self.investmentView.bankScroll=self.backScrollview;
    self.contentScrollview.contentSubviews=@[self.proDetailView,self.profkView,self.prowtView,self.investmentView];
}


-(projectDecView *)proDetailView{
    if (!_proDetailView) {
        _proDetailView=[[projectDecView alloc]initCustomFrome:CGRectMake(0, 0, UISCREEN_WIDTH, self.frame.size.height-44)];
    }
    return _proDetailView;
}
-(projectDecView *)profkView{
    if (!_profkView) {
        _profkView=[[projectDecView alloc]initCustomFrome:CGRectMake(0, 0, UISCREEN_WIDTH, self.frame.size.height-44)];
    }
    return _profkView;
}

-(QuestView *)prowtView{
    if (!_prowtView) {
        _prowtView=[[QuestView alloc]initCustomFrome:CGRectMake(0, 0, UISCREEN_WIDTH, self.frame.size.height-44)];
    }
    return _prowtView;
}
-(InvestmentView *)investmentView{
    if (!_investmentView) {
        _investmentView=[[InvestmentView alloc]initCustomFrome:CGRectMake(0, 0, UISCREEN_WIDTH, self.frame.size.height-44)];
    }
    return _investmentView;
}


- (IBAction)chooseTypeBtnClick:(UIButton *)sender {
    self.contentScrollview.contentOffset = CGPointMake((sender.tag - 1020)*UISCREEN_WIDTH, 0);
    self.lineX.constant=UISCREEN_WIDTH/4*(sender.tag-1020);
    for (int i=0; i<4; i++) {
        UIButton *btn=[self.Topsuperview viewWithTag:1020+i];
        if (btn.tag==sender.tag) {
            btn.enabled=NO;
        }else{
            btn.enabled=YES;
        }
    }
    [self reloadWithModel:self.projectModel];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.contentScrollview) {
        if (scrollView.contentOffset.x==0) {
            [self slideBtn:[self.Topsuperview viewWithTag:1020]];
        }else if (scrollView.contentOffset.x==UISCREEN_WIDTH){
            [self slideBtn:[self.Topsuperview viewWithTag:1021]];
        }else if(scrollView.contentOffset.x==2*UISCREEN_WIDTH){
            [self slideBtn:[self.Topsuperview viewWithTag:1022]];
        }else{
            [self slideBtn:[self.Topsuperview viewWithTag:1023]];
        }
        [self reloadWithModel:self.projectModel];
    }
}
-(void)slideBtn:(UIButton *)sender{
    for (int i=0; i<4; i++) {
        UIButton *btn=[self.Topsuperview viewWithTag:1020+i];
        if (btn.tag==sender.tag) {
            btn.enabled=NO;
        }else{
            btn.enabled=YES;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView==self.contentScrollview) {
        self.lineX.constant = scrollView.contentOffset.x/4;
        self.currenttype=scrollView.contentOffset.x/UISCREEN_WIDTH+1;
    }
}
-(void)reloadWithModel:(projectDetailModel *)model{
    if (self.currenttype==1) {
        self.projectModel=model;
        [self.proDetailView projectReloadWithData:model andType:self.currenttype];
    }else if (self.currenttype==2){
        [self.profkView projectReloadWithData:model andType:self.currenttype];
    }else if (self.currenttype==3){
        if (model.productId!=nil&&![model.productId isEqualToString:@""]&&![model.productId isKindOfClass:[NSNull class]]) {
            [self.prowtView RefirshUI:model.productId];
        }
        
    }else if (self.currenttype==4){
        if (model.productId!=nil&&![model.productId isEqualToString:@""]&&![model.productId isKindOfClass:[NSNull class]]) {
            [self.investmentView RefirshUIModel:model];
        }
        
    }
}
-(UILabel *)headerLab{
    if (!_headerLab) {
        _headerLab=[[UILabel alloc]initWithFrame:CGRectMake(0, -1*responseHeight-20, self.bounds.size.width, 30)];
        _headerLab.textAlignment=NSTextAlignmentCenter;
        _headerLab.font=[UIFont systemFontOfSize:14];
        _headerLab.textColor=RGB(0x666666);
    }
    return _headerLab;
}
-(void)investmentPullupView{
     [self.delegate pullUpView];
}
-(void)pullUpView{
    [self.delegate pullUpView];
}
-(void)questpullUpView{
    [self.delegate pullUpView];
}
@end
