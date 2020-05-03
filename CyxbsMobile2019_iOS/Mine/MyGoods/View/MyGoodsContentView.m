//
//  MyGoodsContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsContentView.h"

@interface MyGoodsContentView ()

/// 返回按钮
@property (nonatomic, weak) UIButton *backButton;

@end


@implementation MyGoodsContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        self.backButton = backButton;
        
        UIButton *didNotRecievedButton = [[UIButton alloc] init];;
        if (@available(iOS 11.0, *)) {
            [didNotRecievedButton setTitleColor:[UIColor colorNamed:@"Mine_CheckIn_TitleView"] forState:UIControlStateNormal];
        } else {
            [didNotRecievedButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
        }
        [didNotRecievedButton setTitle:@"未领取" forState:UIControlStateNormal];
        didNotRecievedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        didNotRecievedButton.backgroundColor = [UIColor clearColor];
        [didNotRecievedButton addTarget:self action:@selector(didNotRecievedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:didNotRecievedButton];
        self.didNotRecievedButton = didNotRecievedButton;
        
        UIButton *recievedButton = [[UIButton alloc] init];
        if (@available(iOS 11.0, *)) {
            [recievedButton setTitleColor:[UIColor colorNamed:@"Mine_CheckIn_TitleView"] forState:UIControlStateNormal];
        } else {
            [recievedButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
        }
        [recievedButton setTitle:@"已领取" forState:UIControlStateNormal];
        recievedButton.alpha = 0.49;
        [recievedButton addTarget:self action:@selector(recievedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recievedButton];
        self.recievedButton = recievedButton;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UITableView *didNotrecievedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 500) style:UITableViewStyleGrouped];
        if (@available(iOS 13.0, *)) {
            didNotrecievedTableView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            didNotrecievedTableView.backgroundColor = [UIColor whiteColor];
        }
        didNotrecievedTableView.rowHeight = 112;
        didNotrecievedTableView.sectionHeaderHeight = 0.1;
        didNotrecievedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:didNotrecievedTableView];
        self.didNotRecievedTableView = didNotrecievedTableView;
        
        UITableView *recievedTableView = [[UITableView alloc] initWithFrame:CGRectMake(MAIN_SCREEN_W, 0, MAIN_SCREEN_W, 500) style:UITableViewStyleGrouped];
        if (@available(iOS 13.0, *)) {
            recievedTableView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            recievedTableView.backgroundColor = [UIColor whiteColor];
        }
        recievedTableView.rowHeight = 112;
        recievedTableView.sectionHeaderHeight = 0.1;
        recievedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:recievedTableView];
        self.recievedTableView = recievedTableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(17);
        make.top.equalTo(self).offset(26);
        make.width.height.equalTo(@19);
    }];
    
    [self.didNotRecievedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing).offset(25);
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.recievedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.didNotRecievedButton.mas_trailing).offset(21);
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.didNotRecievedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView);
        if (IS_IPHONEX) {
            make.bottom.equalTo(self).offset(-80);
        } else {
            make.bottom.equalTo(self).offset(-40);
        }
        make.top.equalTo(self.backButton.mas_bottom).offset(31);
        make.width.equalTo(@(MAIN_SCREEN_W));
    }];
    
    [self.recievedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.didNotRecievedTableView.mas_trailing);
        make.top.equalTo(self.didNotRecievedTableView);
        if (IS_IPHONEX) {
            make.bottom.equalTo(self).offset(-80);
        } else {
            make.bottom.equalTo(self).offset(-40);
        }
        make.width.equalTo(@(MAIN_SCREEN_W));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self);
        make.top.equalTo(self.backButton.mas_bottom).offset(31);
        make.width.equalTo(@(MAIN_SCREEN_W));
        make.trailing.equalTo(self.recievedTableView);
    }];
}

- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

- (void)didNotRecievedButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didNotRecievedButtonClicked:)]) {
        [self.delegate didNotRecievedButtonClicked:sender];
    }
}

- (void)recievedButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(recievedButtonClicked:)]) {
        [self.delegate recievedButtonClicked:sender];
    }
}

@end
