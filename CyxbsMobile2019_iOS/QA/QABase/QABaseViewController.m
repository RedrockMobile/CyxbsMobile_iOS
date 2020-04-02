//
//  QABaseViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/3/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QABaseViewController.h"

@interface QABaseViewController ()
@end

@implementation QABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHexString:@""];
    [self customNavigationBar];
    [self customNavigationRightButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)customNavigationBar{
    UIView *backgroundView = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
        backgroundView.backgroundColor = [UIColor colorNamed:@"QANavigationBackgroundColor"];;
    } else {
        backgroundView.backgroundColor = UIColor.whiteColor;
    }
    [self.view addSubview:backgroundView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:21];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];;
    } else {
        titleLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    }
    [backgroundView addSubview:titleLabel];
    
    UIView *backButtonView = [[UIView alloc]init];
    backButtonView.backgroundColor = UIColor.clearColor;
    [backgroundView addSubview:backButtonView];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setImage:[UIImage imageNamed:@"QANavigationBackButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIGestureRecognizer *tapToBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [backButtonView addGestureRecognizer:tapToBack];
    [backgroundView addSubview:backButton];
    
    self.rightButton = [[UIButton alloc]init];
//    [self.rightButton setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [backgroundView addSubview:self.rightButton];
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [backgroundView addSubview:separateView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@TOTAL_TOP_HEIGHT);
    }];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.bottom.mas_equalTo(backgroundView.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    [backButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(17);
        make.top.equalTo(backgroundView).offset(STATUSBARHEIGHT);
        make.width.equalTo(@30);
        make.height.equalTo(@44);
    }];
       
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(17);
        make.top.equalTo(backgroundView).offset(STATUSBARHEIGHT + 11);
        make.width.equalTo(@9);
        make.height.equalTo(@20);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView).offset(-17);
        make.top.equalTo(backgroundView).offset(STATUSBARHEIGHT + 11);
        make.width.equalTo(@15);
        make.height.equalTo(@20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        //        make.bottom.equalTo(backgroundView).offset(-20);
        make.left.equalTo(backButton).offset(20);
        make.centerY.equalTo(backButton);
    }];
    
}
- (void)customNavigationRightButton{
    [self.rightButton setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
