//
//  SelfSafeView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SelfSafeView.h"
#import <Masonry.h>

@interface SelfSafeView()

@property (nonatomic, strong) UILabel *barTitle;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *arrowImageView;


@end

@implementation SelfSafeView

- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1];
        
        ///返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"密码返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        _backBtn = backBtn;
        
        ///标题
        UILabel *barTitle = [[UILabel alloc] init];
        barTitle.text = @"账号与安全";
        barTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 21];
        barTitle.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        barTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:barTitle];
        _barTitle = barTitle;
        
        ///列表
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.layer.cornerRadius = 16;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.rowHeight = 61;
        tableView.scrollEnabled = YES;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        _tableView = tableView;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0567);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0453);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.024);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0228);
    }];
    
    [_barTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0481);
        make.left.mas_equalTo(_backBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.0293);
        make.width.greaterThanOrEqualTo(@(SCREEN_WIDTH * 0.2907));
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0358);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.106);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

#pragma mark - View的代理
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    cell.textColor = [UIColor colorWithRed:25.0/255.0 green:56.0/255.0 blue:102.0/255.0 alpha:1];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"修改密码";
            break;
            
        case 1:
            cell.textLabel.text = @"修改密保";
            break;
            
        case 2:
            cell.textLabel.text = @"修改绑定邮箱";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectedChangePassword)]) {
                [self.delegate selectedChangePassword];
            }
            break;
            
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectedChangeQuestion)]) {
                [self.delegate selectedChangeQuestion];
            }
            break;
            
        case 2:
            if ([self.delegate respondsToSelector:@selector(selectedChangeEmail)]) {
                [self.delegate selectedChangeEmail];
            }
            break;
            
        default:
            break;
    }
}

@end
