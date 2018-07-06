//
//  projectDecView.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/29.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "projectDecView.h"
#import "BorrowerInfoOneTVCell.h"
#import "BorrowerInfoTwoTVCell.h"
#import "BorrowerLabItemTVCell.h"
#import "FkRZTVCell.h"
#import "FKZLTVCell.h"
static float responseHeight=30;
@interface projectDecView()<UITableViewDelegate,UITableViewDataSource>
@property (assign ,nonatomic)NSInteger currentType;
@property (strong,nonatomic)projectDetailModel *model;
@property (strong,nonatomic)NSArray *sortArr;
@property (assign,nonatomic)BOOL Isfkld;//是否有风控亮点
@property (assign,nonatomic)BOOL Isfkrz;//是否有风控认证
@property (assign,nonatomic)BOOL Isfkzl;//是否有风控资料
@end
@implementation projectDecView
-(instancetype)initCustomFrome:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.tableview=[[StateTableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableview.estimatedRowHeight=74;
    self.tableview.rowHeight=UITableViewAutomaticDimension;
    self.tableview.sectionFooterHeight = 0.1;
    self.tableview.sectionHeaderHeight=0.1;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BorrowerInfoOneTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BorrowerInfoOneTVCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BorrowerInfoTwoTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BorrowerInfoTwoTVCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BorrowerLabItemTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FkRZTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FkRZTVCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FKZLTVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FKZLTVCell class])];
    [self addSubview:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.currentType) {
        case 1:
            return 1+self.sortArr.count;
            break;
        case 2:
        {
            if (self.Isfkld&&self.Isfkrz&&self.Isfkzl) {
                return 3;
            }else if ((self.Isfkld&&self.Isfkrz&&!self.Isfkzl)||(self.Isfkld&&!self.Isfkrz&&!self.Isfkzl)||(!self.Isfkld&&self.Isfkrz&&!self.Isfkzl)){
                return 2;
            }else if (!self.Isfkld&&!self.Isfkrz&&!self.Isfkzl)
            {
                return 0;
            }
            return 1;
        }
            break;
        default:
            break;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentType) {
        case 1:
            if (indexPath.section==0) {
                if (self.model.borrowerList.count>1&&self.model.borrowerList.count<4) {
                    return 62+46*self.model.borrowerList.count;
                }
            }
            break;
        case 2:
            if (!self.Isfkld&&self.Isfkrz&&!self.Isfkzl) {
                if (indexPath.section==0) {
                    return 32+46+((self.model.extend_data.count/2+self.model.extend_data.count%2)-1)*30;
                }
            }
            if (indexPath.section==1) {
                return 32+46+((self.model.extend_data.count/2+self.model.extend_data.count%2)-1)*30;
            }
            break;
        default:
            break;
    }
    
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentType) {
        case 1:
        {
            if (indexPath.section==0) {
                if (self.model.borrowerList.count>1) {
                     BorrowerInfoTwoTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerInfoTwoTVCell class])];
                    [cell configureUIwithData:self.model.borrowerList];
                    return cell;
                }else{
                     BorrowerInfoOneTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerInfoOneTVCell class])];
                    [cell configureUIWithData:self.model.borrowerList];
                    return cell;
                }
                
            }else{
                
                BorrowerLabItemTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
                cell.itemName.text=self.sortArr[indexPath.section-1][@"attrName"];
                cell.contentLab.text=self.sortArr[indexPath.section-1][@"attrValue"];
                return cell;
            }
        }
            break;
        case 2:
        {
            if (self.Isfkld&&self.Isfkrz&&self.Isfkzl) {
                if (indexPath.section==0) {
                    BorrowerLabItemTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
                    cell.itemName.text=@"风控亮点";
                    cell.contentLab.text=self.model.extend;
                    return cell;
                }else if(indexPath.section==1){
                    FkRZTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FkRZTVCell class])];
                    [cell confogureUIWithData:self.model.extend_data];
                    return cell;
                }else{
                    FKZLTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKZLTVCell class])];
                    [cell configreUiData:self.model.imags];
                    return cell;
                }
            }else if (self.Isfkld&&self.Isfkrz&&!self.Isfkzl){
                if (indexPath.section==0) {
                    BorrowerLabItemTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
                    cell.itemName.text=@"风控亮点";
                    cell.contentLab.text=self.model.extend;
                    return cell;
                }else if(indexPath.section==1){
                    FkRZTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FkRZTVCell class])];
                    [cell confogureUIWithData:self.model.extend_data];
                    return cell;
                }
            }else if (self.Isfkld&&!self.Isfkrz&&self.Isfkzl){
                if (indexPath.section==0) {
                    BorrowerLabItemTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
                    cell.itemName.text=@"风控亮点";
                    cell.contentLab.text=self.model.extend;
                    return cell;
                }else{
                    FKZLTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKZLTVCell class])];
                    [cell configreUiData:self.model.imags];
                    return cell;
                }
            }else if (!self.Isfkld&&self.Isfkrz&&self.Isfkzl){
                if(indexPath.section==0){
                    FkRZTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FkRZTVCell class])];
                    [cell confogureUIWithData:self.model.extend_data];
                    return cell;
                }else{
                    FKZLTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKZLTVCell class])];
                    [cell configreUiData:self.model.imags];
                    return cell;
                }
            }else if (self.Isfkld){
                BorrowerLabItemTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BorrowerLabItemTVCell class])];
                cell.itemName.text=@"风控亮点";
                cell.contentLab.text=self.model.extend;
                return cell;
            }else if (self.Isfkrz){
                FkRZTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FkRZTVCell class])];
                [cell confogureUIWithData:self.model.extend_data];
                return cell;
            }else if (self.Isfkzl){
                FKZLTVCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FKZLTVCell class])];
                [cell configreUiData:self.model.imags];
                return cell;
            }
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}
-(NSArray *)dealWithDatatoSort:(NSArray *)arr{
    NSMutableArray *mutarr=[NSMutableArray arrayWithCapacity:0];
    [mutarr addObjectsFromArray:arr];
    NSMutableArray *NewMutArr=[NSMutableArray arrayWithCapacity:0];
    [NewMutArr removeAllObjects];
    if (mutarr.count>0) {
        for (int i=0; i<mutarr.count-1; i++) {
            for (int j=0; j<mutarr.count-1-i; j++) {
                NSDictionary *fistDic=mutarr[j];
                NSDictionary *secondDic=mutarr[j+1];
                if ([fistDic[@"sort"] integerValue]>[secondDic[@"sort"] integerValue]) {
                   [mutarr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    
                }
            }
        }
        
        for (int i=0; i<mutarr.count; i++) {
            NSDictionary *dic=mutarr[i];
            if (![dic[@"attrValue"] isEqualToString:@""]&&dic[@"attrValue"]!=nil&&![dic[@"attrValue"] isKindOfClass:[NSNull class]]) {
                [NewMutArr addObject:dic];
            }
        }
    }
    return NewMutArr;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat contentOffSetY=scrollView.contentOffset.y;
    CGFloat beforeHeight=responseHeight*(-1);
    NSLog(@"------(%f)",contentOffSetY);
    if (contentOffSetY<beforeHeight) {
        NSLog(@"上一页");
        [self.delegate pullUpView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==self.tableview) {
        if (self.tableview.contentOffset.y<0) {
            //            [self.text3.tableview setContentInset:UIEdgeInsetsMake(self.text3.tableview.contentOffset.y, 0, 0, 0)];
            [self.bankScroll setContentOffset:self.tableview.contentOffset];
        }else if (self.tableview.contentOffset.y>0){
            //            self.text3.tableview.bounces=YES;
        }
    }
    
}
-(void)projectReloadWithData:(projectDetailModel *)model andType:(NSInteger)type{
    if (self.model==nil||[self.model isKindOfClass:[NSNull class]]) {
        self.model=model;
        self.currentType=type;
        if(type==1){
            self.sortArr=[self dealWithDatatoSort:self.model.sttrData];
        }else if (type==2){
            if (![self.model.extend isEqualToString:@""]&&![self.model.extend isKindOfClass:[NSNull class]]&&self.model.extend!=nil) {
                self.Isfkld=YES;
            }else{
                self.Isfkld=NO;
            }
            
            if (self.model.extend_data.count>0) {
                self.Isfkrz=YES;
            }else{
                self.Isfkrz=NO;
            }
            if (self.model.imags.count>0) {
                self.Isfkzl=YES;
            }else{
                self.Isfkzl=NO;
            }
        }
        [self.tableview reloadData];

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
