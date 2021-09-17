//
//  PMPBasicViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPBasicNavBarController.h"

@interface PMPBasicNavBarController ()

/// 顶部的bar
@property (nonatomic,strong) UIView * topBarView;
/// 控制器标题
@property (nonatomic,strong) UILabel * VCTitleLabel;
/// 返回按钮
@property (nonatomic,strong) UIButton * backBtn;

@end

@implementation PMPBasicNavBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    // configure self
    self.view.backgroundColor = [UIColor colorNamed:@"white&black"];
    
    // configure topBarView
    [self.view addSubview:self.topBarView];
    
    //获取状态栏高度
    double statusBarH = [[UIApplication sharedApplication].windows objectAtIndex:0].windowScene.statusBarManager.statusBarFrame.size.height;
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    // 立即将导航栏布局，将 frame 的值所固定
    // 以便在不使用 autoLayout/masonry 的情况下也可以得到导航栏的位置信息
    [self.view layoutIfNeeded];
    
    // configure backBtn
    [self.topBarView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView);
        make.centerY.equalTo(self.topBarView);
        make.height.width.mas_equalTo(44);
    }];
    
    // configure VCTitlelabel
    [self.topBarView addSubview:self.VCTitleLabel];
    [self.VCTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarView);
        make.left.mas_equalTo(self.backBtn.mas_right);
    }];
}

#pragma mark - private

- (CGFloat)getTopBarViewHeight {
    return self.topBarView.frame.size.height + self.topBarView.frame.origin.y;
}

#pragma mark - event response

/// 点击 返回按钮 后调用的方法
- (void)backBtnClicked:(UIButton *)sender {
    // 添加一个小动画
//    CABasicAnimation * animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)[UIColor lightGrayColor].CGColor;
//    animation.duration = 0.1;
//    animation.autoreverses = YES;
//    [sender.layer addAnimation:animation forKey:@"backgroundColor"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.navigationController != nil) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else if (self.presentingViewController != nil) {
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        }
//    });
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [UIColor lightGrayColor];
    } completion:^(BOOL finished) {
        if (self.navigationController != nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.presentingViewController != nil) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - setter

- (void)setVCTitleStr:(NSString *)VCTitleStr {
    _VCTitleStr = VCTitleStr;
    if(self.topBarView){
        self.VCTitleLabel.text = _VCTitleStr;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.VCTitleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.VCTitleLabel.textColor = titleColor;
}

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor {
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBarView.backgroundColor = topBarBackgroundColor;
}

#pragma mark - getter

- (UIView *)topBarView {
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] initWithFrame:(CGRectZero)];
    }
    return _topBarView;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:(CGRectZero)];
        [_backBtn setImage:[UIImage imageNamed:@"BasicClass_navBar_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.layer.cornerRadius = 10;
        _backBtn.backgroundColor = [UIColor clearColor];
    }
    return _backBtn;
}

- (UILabel *)VCTitleLabel {
    if (_VCTitleLabel == nil) {
        _VCTitleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _VCTitleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:22];
        _VCTitleLabel.textColor = [UIColor colorNamed:@"white&white"];
        [_VCTitleLabel sizeToFit];
    }
    return _VCTitleLabel;
}

@end
