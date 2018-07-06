
//
//  ReturnMoneyPlayVController.m
//  midabao_project
//
//  Created by 杨路 on 2017/8/15.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "ReturnMoneyPlayVController.h"
#import "ExclusiveButton.h"
#import "HorizontalScrollView.h"
#import "ReturnMoneyView.h"
@interface ReturnMoneyPlayVController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;
@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusiveBtn;
@property (weak, nonatomic) IBOutlet HorizontalScrollView *contentView;
@property (strong,nonatomic)ReturnMoneyView *allView;
@property (strong,nonatomic)ReturnMoneyView *waitView;
@property (strong,nonatomic)ReturnMoneyView *outView;
@end

@implementation ReturnMoneyPlayVController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self chanageNavigationBarAlpha:1];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:NavigationBar_Back] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        
    }];
    self.contentView.contentSubviews=@[self.allView,self.waitView,self.outView];
    [[self.contentView presentingSubview] beginRefresh];
    // Do any additional setup after loading the view.
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        
        self.lineX.constant = scrollView.contentOffset.x/3;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        if (scrollView.contentOffset.x==0) {
            [self.exclusiveBtn setButtonInvalid:[self.exclusiveBtn.invalidButton.superview viewWithTag:300]];
        }else if (scrollView.contentOffset.x==UISCREEN_WIDTH){
            [self.exclusiveBtn setButtonInvalid:[self.exclusiveBtn.invalidButton.superview viewWithTag:301]];
        }else {
            [self.exclusiveBtn setButtonInvalid:[self.exclusiveBtn.invalidButton.superview viewWithTag:302]];
        }
    }
}
-(void)setExclusiveBtn:(ExclusiveButton *)exclusiveBtn{
    _exclusiveBtn=exclusiveBtn;
    @weakify(self)
    _exclusiveBtn.invalidButtonDidChangeBlock = ^(UIButton *sender) {
        @strongify(self)
        self.contentView.contentOffset = CGPointMake((sender.tag - 300)*self.contentView.width, 0);
        self.lineX.constant=UISCREEN_WIDTH/3*(sender.tag-300);
        [[self.contentView presentingSubview] beginRefresh];
    };
}
-(ReturnMoneyView *)allView{
    if (!_allView) {
        _allView=[ReturnMoneyView customViewWithState:0];
    }
    return _allView;
}
-(ReturnMoneyView *)waitView{
    if (!_waitView) {
        _waitView=[ReturnMoneyView customViewWithState:1];
    }
    return _waitView;
}
-(ReturnMoneyView *)outView{
    if (!_outView) {
        _outView=[ReturnMoneyView customViewWithState:2];
    }
    return _outView;
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
