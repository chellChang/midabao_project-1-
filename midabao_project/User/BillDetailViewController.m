
//
//  BillDetailViewController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/18.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "BillDetailViewController.h"

@interface BillDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *explanLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiNumber;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *bottomexplanLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomtime;
@property (weak, nonatomic) IBOutlet UIImageView *bottomPointImg;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    [self refirshUI];
    // Do any additional setup after loading the view.
}
-(void)refirshUI{
    NSString *str=[NSString stringWithFormat:@"%lf", [CommonTools cutOutCGFloatDecimal:self.capitalModel.price preserve:2]];
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"###,##0.00"];
    self.moneyLab.text=[NSString stringWithFormat:@"%@%@",self.capitalModel.capitaloperator==1?@"+":@"-",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]]];
    self.jiaoyiNumber.text=self.capitalModel.transNumber;
    self.createTime.text=self.capitalModel.crateTimeDetail;
    self.explanLab.text=self.capitalModel.transExplain;
    switch (self.capitalModel.transStatus) {
        case 1://处理中
        {
            self.stateImage.image=[UIImage imageNamed:@"exchangechulizhongIcon"];
            self.stateLab.text=@"处理中...";
            self.bottomtime.textColor=RGB(0x999999);
            self.bottomexplanLab.textColor=RGB(0x999999);
            self.bottomPointImg.image=[UIImage imageNamed:@"bluePoint"];
            self.bottomLineView.backgroundColor=RGB(0xAECAF7);
            self.bottomtime.text=[NSString stringWithFormat:@"预计到账时间%@",self.capitalModel.estiTime];
            switch (self.capitalModel.type) {
                case 1://充值
                {
                    self.bottomexplanLab.text=@"充值成功";
                    
                }
                    break;
                case 2://提现
                {
                    self.bottomexplanLab.text=@"提现成功";
                }
                    break;
                case 3://投资
                {
                    self.bottomexplanLab.text=@"投资成功";
                }
                    break;
                case 4://回款
                {
                    self.bottomexplanLab.text=@"回款成功";
                }
                    break;
                default://用户奖励
                {
                    self.bottomexplanLab.text=@"奖励到账";
                }
                    break;
            }
        }
            break;
        case 2://交易成功
        {
            self.stateImage.image=[UIImage imageNamed:@"exchangesuccessIcon"];
            self.stateLab.text=@"交易成功";
            self.bottomtime.textColor=RGB(0x333333);
            self.bottomexplanLab.textColor=RGB(0x333333);
            self.bottomPointImg.image=[UIImage imageNamed:@"deepbluePoint"];
            self.bottomLineView.backgroundColor=RGB(0x3379EA);
            self.bottomtime.text=self.capitalModel.endTimeDetail;
            switch (self.capitalModel.type) {
                case 1://充值
                {
                    self.bottomexplanLab.text=@"充值成功";
                }
                    break;
                case 2://提现
                {
                    self.bottomexplanLab.text=@"提现成功";
                }
                    break;
                case 3://投资
                {
                    self.bottomexplanLab.text=@"投资成功";
                }
                    break;
                case 4://回款
                {
                    self.bottomexplanLab.text=@"回款成功";
                }
                    break;
                default://用户奖励
                {
                    self.bottomexplanLab.text=@"奖励到账";
                }
                    break;
            }
        }
            break;
        case 3://交易失败
        {
            self.stateImage.image=[UIImage imageNamed:@"exchangeshibaiIcon"];
            self.stateLab.text=@"交易失败";
            self.bottomtime.textColor=RGB(0x333333);
            self.bottomexplanLab.textColor=RGB(0x333333);
            self.bottomPointImg.image=[UIImage imageNamed:@"deepbluePoint"];
            self.bottomLineView.backgroundColor=RGB(0x3379EA);
            self.bottomtime.text=self.capitalModel.endTimeDetail;
            switch (self.capitalModel.type) {
                case 1://充值
                {
                    self.bottomexplanLab.text=@"充值失败";
                }
                    break;
                case 2://提现
                {
                    self.bottomexplanLab.text=@"提现失败";
                }
                    break;
                case 3://投资
                {
                    self.bottomexplanLab.text=@"投资失败";
                }
                    break;
                case 4://回款
                {
                    self.bottomexplanLab.text=@"回款失败";
                }
                    break;
                default://用户奖励
                {
                    self.bottomexplanLab.text=@"奖励到账失败";
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
