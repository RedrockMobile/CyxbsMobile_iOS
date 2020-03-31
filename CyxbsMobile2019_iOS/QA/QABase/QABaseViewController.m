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
    [self customNavigationBar];
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
    
    
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setImage:[UIImage imageNamed:@"QANavigationBackButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:backButton];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(17);
        make.top.equalTo(backgroundView).offset(11);
        make.width.equalTo(@9);
        make.height.equalTo(@20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        //        make.bottom.equalTo(backgroundView).offset(-20);
        make.left.equalTo(backButton).offset(15);
        make.centerY.equalTo(backButton);
    }];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
