//
//  MineAboutContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/4.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineAboutContentView.h"
#import "LearnMoreViewController.h"
#import "TopBarBasicViewController.h"
@interface MineAboutContentView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *appNameLabel;
@property (nonatomic, weak) UILabel *appVersionLable;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UILabel *corporationLabel;
@property (nonatomic, weak) UILabel *copyrightLabel;

@end

@implementation MineAboutContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_Store_ContainerColor"];
        } else {
            self.backgroundColor = [UIColor colorWithRed:239/255.0 green:242/255.0 blue:247/255.0 alpha:1];
        }
        
        UIButton *backButton = [[UIButton alloc] init];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(5.5, 10, 5.5, 11);
        [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [self addSubview:backButton];
        self.backButton = backButton;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"关于我们";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (@available(iOS 11.0, *)) {
            titleLabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:48/255.0 blue:91/255.0 alpha:1];
        }
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"appIcon"];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.layer.cornerRadius = 24;
        iconImageView.clipsToBounds = YES;
        [self addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        UILabel *appNameLabel = [[UILabel alloc] init];
        appNameLabel.text = @"掌上重邮";
        appNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        if (@available(iOS 11.0, *)) {
            appNameLabel.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
        } else {
            appNameLabel.textColor = [UIColor colorWithRed:41/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        [self addSubview:appNameLabel];
        self.appNameLabel = appNameLabel;
        
        UILabel *appVersionLabel = [[UILabel alloc] init];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        appVersionLabel.text = [NSString stringWithFormat:@"Version %@", version];
        appVersionLabel.font = [UIFont systemFontOfSize:13];
        appVersionLabel.textColor = self.appNameLabel.textColor;
        appVersionLabel.alpha = 0.57;
        [self addSubview:appVersionLabel];
        self.appVersionLable = appVersionLabel;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            tableView.backgroundColor = [UIColor colorNamed:@"Mine_Main_HeaderColor"];
        } else {
            tableView.backgroundColor = [UIColor whiteColor];
        }
        tableView.layer.cornerRadius = 16;
        tableView.separatorColor = [UIColor clearColor];
        tableView.sectionHeaderHeight = 0;
        tableView.rowHeight = 61;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        UILabel *corporationLabel = [[UILabel alloc] init];
        corporationLabel.text = @"红岩网校工作站出品";
        corporationLabel.font = [UIFont systemFontOfSize:11];
        if (@available(iOS 11.0, *)) {
            corporationLabel.textColor = [UIColor colorNamed:@"Mine_About_CopyrightColor"];
        } else {
            corporationLabel.textColor = [UIColor colorWithRed:41/255.0 green:65/255.0 blue:105/255.0 alpha:0.4];
        }
        [self addSubview:corporationLabel];
        self.corporationLabel = corporationLabel;
        
        UILabel *copyrightLabel = [[UILabel alloc] init];
        copyrightLabel.text = @"Copyright © 2015-2020 All Rights Reserverd";
        copyrightLabel.textAlignment = NSTextAlignmentCenter;
        copyrightLabel.font = [UIFont systemFontOfSize:11];
        if (@available(iOS 11.0, *)) {
            copyrightLabel.textColor = [UIColor colorNamed:@"Mine_About_CopyrightColor"];
        } else {
            copyrightLabel.textColor = [UIColor colorWithRed:41/255.0 green:65/255.0 blue:105/255.0 alpha:0.4];
        }
        [self addSubview:copyrightLabel];
        self.copyrightLabel = copyrightLabel;
        [self addLearnMoreBtns];
    }
    return self;
}

/// 添加 “服务协议”、“隐私条款” 按钮
- (void)addLearnMoreBtns{
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    
    
    UIButton *leftBtn = [self getLearnMoreBtn];
    [backView addSubview:leftBtn];
    
    [leftBtn setTitle:@"服务协议 " forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *rightBtn = [self getLearnMoreBtn];
    [backView addSubview:rightBtn];
    
    [rightBtn setTitle:@"| 隐私条款" forState:UIControlStateNormal];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.bottom.equalTo(backView);
        make.left.equalTo(leftBtn.mas_right);
    }];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.corporationLabel.mas_top).offset(-0.024*SCREEN_WIDTH);
        make.centerX.equalTo(self);
        make.height.equalTo(leftBtn);
    }];
    
}
- (void)leftBtnClicked{
    LearnMoreViewController *vc = [[LearnMoreViewController alloc] initWithType:LMVCTypeServiceAgreement];
//    TopBarBasicViewController *vc = [[TopBarBasicViewController alloc] init];
//    vc.VCTitleStr = @"掌上重邮";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)rightBtnClicked{
    LearnMoreViewController *vc = [[LearnMoreViewController alloc] initWithType:LMVCTypePrivacyClause];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (UIButton*)getLearnMoreBtn{
    UIButton *btn = [[UIButton alloc] init];
    if (@available(iOS 11.0, *)) {
        [btn setTitleColor:[UIColor colorNamed:@"44_223_255&94_223_250"] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor colorWithRed:44/255.0 green:223/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    }
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:11]];
    return btn;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(17 - 10); // 减去10的按钮内边距
        make.top.equalTo(self).offset(41);
        make.width.height.equalTo(@30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing).offset(11 - 11); // 减去21的按钮内边距
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(37);
        make.height.width.equalTo(@(MAIN_SCREEN_H * 0.154));
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(11);
    }];
    
    [self.appVersionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(3);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appVersionLable.mas_bottom).offset(42);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(16);
    }];
    
    [self.corporationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.copyrightLabel.mas_top).offset(-5);
    }];
    
    if (IS_IPHONEX) {
        [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-40);
        }];
    } else {
        [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
        }];
    }
}


#pragma mark - contentView代理
- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}


#pragma mark - tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    cell.textLabel.textColor = self.appNameLabel.textColor;
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"功能介绍";
            break;
            
        case 1:
            cell.textLabel.text = @"产品官网";
            break;
            
        case 2:
            cell.textLabel.text = @"意见与反馈";
            break;
            
        case 3:
            cell.textLabel.text = @"版本更新";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectedIntroduction)]) {
                [self.delegate selectedIntroduction];
            }
            break;
            
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectedProductWebsite)]) {
                [self.delegate selectedProductWebsite];
            }
            break;
            
        case 2:
            if ([self.delegate respondsToSelector:@selector(selectedFeedBack)]) {
                [self.delegate selectedFeedBack];
            }
            break;
            
        case 3:
            if ([self.delegate respondsToSelector:@selector(selectedUpdateCheck)]) {
                [self.delegate selectedUpdateCheck];
            }
            break;
            
        default:
            break;
    }
}

@end
