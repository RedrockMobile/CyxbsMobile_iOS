//
//  TopBarBasicViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//带有一个顶部导航条的基类

#import "TopBarBasicViewController.h"

@interface TopBarBasicViewController ()

@property (nonatomic,strong)UILabel *VCTitleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIView *blackLine;
@end

@implementation TopBarBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"248_249_252&0_1_1"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
    
}

//MARK: -重写的方法:
//调用这个方法自动完成顶部自定义导航条的设置
- (void)setVCTitleStr:(NSString *)VCTitleStr{
    _VCTitleStr = VCTitleStr;
    if(self.topBarView==nil){
        [self addTopBarView];
        [self addVCTitleWithStr:VCTitleStr];
        [self addBackBtn];
        [self addBlackLine];
    }else{
        self.VCTitleLabel.text = _VCTitleStr;
    }
}


//MARK: - UI布局方法:
/// 添加 顶部条 的方法
- (void)addTopBarView{
    UIView *view = [[UIView alloc] init];
    self.topBarView = view;
    [self.view addSubview:view];
    
    int h;
    if (IS_IPHONEX) {
        h = 55;
    }else{
        h = 25;
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(h);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    view.backgroundColor = self.view.backgroundColor;
    
}

/// 添加 控制器标题 的方法
- (void)addVCTitleWithStr:(NSString*)str {
    UILabel *label = [[UILabel alloc] init];
    self.VCTitleLabel = label;
    [self.topBarView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topBarView);
        make.bottom.equalTo(self.topBarView).offset(-10);
    }];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCSemibold size:21];
    
    label.text = str;
    
}

/// 添加 返回按钮 的方法
- (void)addBackBtn{
    UIButton *btn = [[UIButton alloc] init];
    self.backBtn = btn;
    [self.topBarView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView).offset(0.0427*SCREEN_WIDTH);;
        make.centerY.equalTo(self.VCTitleLabel);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(8);
    }];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"空教室返回"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

/// 添加 顶部条的底部黑线 的方法
- (void)addBlackLine{
    UIView *blackLine = [[UIView alloc] init];
    self.blackLine = blackLine;
    [self.topBarView addSubview:blackLine];
    
    if (@available(iOS 11.0, *)) {
        blackLine.backgroundColor = [UIColor colorNamed:@"45_45_45_20&230_230_230_40"];
    } else {
        blackLine.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:0.64];
    }
    
    [blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBarView);
        make.left.right.equalTo(self.topBarView);
        make.height.mas_equalTo(0.5);
    }];
}

//MARK: - 点击按钮后调用方法:
/// 点击 返回按钮 后调用的方法
- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
