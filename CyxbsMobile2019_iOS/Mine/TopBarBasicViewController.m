//
//  TopBarBasicViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Modified by Edioth on 2021/8/12
//  Copyright © 2020 Redrock. All rights reserved.

#import "TopBarBasicViewController.h"

@interface TopBarBasicViewController ()

/// 控制器标题
@property (nonatomic,strong)UILabel *VCTitleLabel;
/// 返回按钮
@property (nonatomic,strong)UIButton *backBtn;
/// 导航条底部的黑线
@property (nonatomic,strong)UIView *splitLine;

@end


@implementation TopBarBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    // configure self
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252&0_1_1"];
    
    // configure topBarView
    [self.view addSubview:self.topBarView];
    //12：47
    //获取状态栏高度
    double statusBarH = getStatusBarHeight_Double;
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    // 立即将导航栏布局，将 frame 的值所固定
    // 以便在不使用 autoLayout/masonry 的情况下也可以得到导航栏的位置信息
    [self.view layoutIfNeeded];
    
    // configure backBtn
    // 左侧原距离 0.0427*SCREEN_WIDTH
    [self.topBarView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView);
        make.centerY.equalTo(self.topBarView);
        make.height.width.mas_equalTo(44);
    }];
    
    // configure VCTitlelabel
    [self.topBarView addSubview:self.VCTitleLabel];
    [_VCTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.topBarView);
    }];

    // configure splitLine
    [self.topBarView addSubview:self.splitLine];
    [self.splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView);
        make.left.right.equalTo(self.topBarView);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - private

- (CGFloat)getTopBarViewHeight {
    return self.topBarView.frame.size.height + self.topBarView.frame.origin.y;
}

#pragma mark - event response

/// 点击 返回按钮 后调用的方法
- (void)backBtnClicked:(UIButton *)sender {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.presentingViewController != nil) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    // 添加一个小动画
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)[UIColor lightGrayColor].CGColor;
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [sender.layer addAnimation:animation forKey:@"backgroundColor"];
}

#pragma mark - setter

- (void)setVCTitleStr:(NSString *)VCTitleStr {
    _VCTitleStr = VCTitleStr;
    if(self.topBarView){
        self.VCTitleLabel.text = _VCTitleStr;
        self.topBarBackgroundColor = self.view.backgroundColor;
    }
}

- (void)setSplitLineHidden:(BOOL)splitLineHidden {
    _splitLineHidden = splitLineHidden;
    self.splitLine.hidden = _splitLineHidden;
}

- (void)setSplitLineColor:(UIColor *)splitLineColor {
    _splitLineColor = splitLineColor;
    self.splitLine.backgroundColor = splitLineColor;
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

- (void)setTopBarViewHidden:(BOOL)topBarViewHidden {
    _topBarViewHidden = topBarViewHidden;
    self.topBarView.hidden = topBarViewHidden;
}

- (void)setTitlePosition:(TopBarViewTitlePosition)titlePosition {
    // 如果设置前后没有改变，就不进行任何操作
    if (self.titlePosition == titlePosition) {
        return;
    }
    _titlePosition = titlePosition;
    if (titlePosition == TopBarViewTitlePositionCenter) {
        [self.VCTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.topBarView);
        }];
    } else {
        [self.VCTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topBarView);
            make.left.mas_equalTo(self.backBtn.mas_right);
        }];
    }
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
        [_backBtn setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.layer.cornerRadius = 10;
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn sizeToFit];
    }
    return _backBtn;
}

- (UILabel *)VCTitleLabel {
    if (_VCTitleLabel == nil) {
        _VCTitleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _VCTitleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:22];
        _VCTitleLabel.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        [_VCTitleLabel sizeToFit];
    }
    return _VCTitleLabel;
}

- (UIView *)splitLine {
    if (_splitLine == nil) {
        _splitLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _splitLine.backgroundColor = [UIColor colorNamed:@"45_45_45_20&230_230_230_40"];
    }
    return _splitLine;
}

@end
