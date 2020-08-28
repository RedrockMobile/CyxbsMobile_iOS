//
//  CheckInContentVIew.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "CheckInContentView.h"

@interface CheckInContentView ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UILabel *yearsLabel;
@property (nonatomic, weak) UILabel *daysLabel;
@property (nonatomic, weak) UILabel *checkInRankLabel;
@property (nonatomic, weak) UILabel *checkInRankPercentLabel;
@property (nonatomic, weak) UIButton *checkInButton;
@property (nonatomic, weak) UIView *dragHintView;
@property (nonatomic, weak) UILabel *storeTitlelabel;
@property (nonatomic, weak) UIButton *myGoodsButton;
@property (nonatomic, weak) UIImageView *scoreImageView;

@end

@implementation CheckInContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.image = [UIImage imageNamed:@"签到背景"];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundImageView.clipsToBounds = YES;
        [self addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        // 返回
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [backBtn setImage:[UIImage imageNamed:@"我的返回-白色"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        self.backBtn = backBtn;

        UILabel *yearsLabel = [[UILabel alloc] init];
        yearsLabel.text = @"2020-2021";
        yearsLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34];
        if (IS_IPHONESE) {
            yearsLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:28];
        }
        yearsLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:yearsLabel];
        self.yearsLabel = yearsLabel;
        
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34];
        if (IS_IPHONESE) {
            weekLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:28];
        }
        weekLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:weekLabel];
        self.weekLabel = weekLabel;

        UILabel *daysLabel = [[UILabel alloc] init];
        daysLabel.text = [NSString stringWithFormat:@"已连续打卡%@天", [UserItemTool defaultItem].checkInDay];
        daysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (IS_IPHONESE) {
            daysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        }
        daysLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:daysLabel];
        self.daysLabel = daysLabel;
        
        UIView *boardView = [[UIView alloc] init];
        boardView.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            boardView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_BaordColor"];
        } else {
            boardView.backgroundColor = [UIColor clearColor];
        }
        boardView.frame = [UIScreen mainScreen].bounds;
        [self addSubview:boardView];
        
        UIView *checkInView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            checkInView.backgroundColor = [UIColor colorNamed:@"Mine_Main_BackgroundColor"];
        } else {
            checkInView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:248/255.0 alpha:1.0];
        }
        checkInView.layer.cornerRadius = 16;
        [self addSubview:checkInView];
        self.checkInView = checkInView;
        
        UILabel *checkInRankLabel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            checkInRankLabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            checkInRankLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        }
        checkInRankLabel.text = [NSString stringWithFormat:@"今日第%@位打卡", [UserItemTool defaultItem].rank];
        checkInRankLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (IS_IPHONESE) {
            checkInRankLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        }
        [checkInView addSubview:checkInRankLabel];
        self.checkInRankLabel = checkInRankLabel;
        
        UILabel *checkInRankPercentLabel = [[UILabel alloc] init];
        checkInRankPercentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.64];
        checkInRankPercentLabel.text = [NSString stringWithFormat:@"超过%d%%的邮子", [UserItemTool defaultItem].rank_Persent.intValue];
        checkInRankPercentLabel.font = [UIFont systemFontOfSize:15];
        if (IS_IPHONESE) {
            checkInRankPercentLabel.font = [UIFont systemFontOfSize:9];
        }
        [self.backgroundImageView addSubview:checkInRankPercentLabel];
        self.checkInRankPercentLabel = checkInRankPercentLabel;
        
        if ([UserItemTool defaultItem].rank.intValue == 0) {
            checkInRankLabel.text = @"你今天还没有签到哦";
            checkInRankPercentLabel.hidden = YES;
        }
        
        UIButton *checkInButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (@available(iOS 11.0, *)) {
            checkInButton.backgroundColor = [UIColor colorNamed:@"Mine_Main_ButtonColor"];
        } else {
            checkInButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1];
        }
        [checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkInButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [checkInButton setTitle:@"签 到" forState:UIControlStateNormal];
        [checkInButton addTarget:self action:@selector(CheckInButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [checkInView addSubview:checkInButton];
        self.checkInButton = checkInButton;
        
        if (![UserItemTool defaultItem].canCheckIn) {
            checkInRankLabel.text = @"假期不能签到哟O(∩_∩)O~~";
            checkInButton.enabled = NO;
            if (@available(iOS 11.0, *)) {
                checkInButton.backgroundColor = [UIColor colorNamed:@"Mine_CanNotCheckInColor"];
            } else {
                checkInButton.backgroundColor = [UIColor colorWithHexString:@"DDDDEE"];
            }
        }
        
        UIView *storeView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            storeView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_StoreViewColor"];
        } else {
            storeView.backgroundColor = [UIColor whiteColor];
        }
        storeView.layer.cornerRadius = 16;
        [self.checkInView addSubview:storeView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentIntegralStore:)];
        [storeView addGestureRecognizer:pan];
        self.storeView = storeView;
        
        UILabel *storeTitlelabel = [[UILabel alloc] init];
        storeTitlelabel.text = @"积分商城";
        storeTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (@available(iOS 11.0, *)) {
            storeTitlelabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            storeTitlelabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        }
        [self.storeView addSubview:storeTitlelabel];
        self.storeTitlelabel = storeTitlelabel;
        
        UIButton *myGoodsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [myGoodsButton setTitle:@"我的商品" forState:UIControlStateNormal];
        myGoodsButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [myGoodsButton setTitleColor:[UIColor colorWithRed:255/255.0 green:161/255.0 blue:146/255.0 alpha:1] forState:UIControlStateNormal];
        myGoodsButton.backgroundColor = [UIColor colorWithRed:248/255.0 green:226/255.0 blue:223/255.0 alpha:1];
        [myGoodsButton addTarget:self action:@selector(myGoodsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.storeView addSubview:myGoodsButton];
        self.myGoodsButton = myGoodsButton;
        
        UIImageView *scoreImageView = [[UIImageView alloc] init];
        scoreImageView.image = [UIImage imageNamed:@"积分"];
        [self.storeView addSubview:scoreImageView];
        self.scoreImageView = scoreImageView;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.text = [NSString stringWithFormat:@"%@", [UserItemTool defaultItem].integral];
        scoreLabel.font = [UIFont systemFontOfSize:18];
        if (@available(iOS 11.0, *)) {
            scoreLabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            scoreLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        }        [self.storeView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        
        // 提醒用户该view可拖拽
        UIView *dragHintView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            dragHintView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_DragHintViewColor"];
        } else {
            dragHintView.backgroundColor = [UIColor colorWithRed:226/255.0 green:237/255.0 blue:251/255.0 alpha:1.0];
        }

        [self.storeView addSubview:dragHintView];
        self.dragHintView = dragHintView;
        
        CheckInBar *bar = [[CheckInBar alloc] init];
        [self.checkInView addSubview:bar];
        self.bar = bar;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yearsLabel);
        make.bottom.equalTo(self.yearsLabel.mas_top).offset(-5);
        make.height.width.equalTo(@19);
    }];
    
    if (IS_IPHONEX) {
        [self.yearsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundImageView).offset(101);
            make.leading.equalTo(self).offset(15);
        }];
    } else {
        [self.yearsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundImageView).offset(57);
            make.leading.equalTo(self).offset(15);
        }];
    }
    
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yearsLabel);
        make.top.equalTo(self.yearsLabel.mas_bottom);
    }];
    
    if (IS_IPHONEX) {
        [self.daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.yearsLabel);
            make.top.equalTo(self.weekLabel.mas_bottom).offset(12);
        }];
    } else {
        [self.daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.yearsLabel);
            make.top.equalTo(self.weekLabel.mas_bottom).offset(8);
        }];
    }
    
    [self.checkInRankPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yearsLabel);
        make.top.equalTo(self.daysLabel.mas_bottom).offset(5);
    }];

    if (IS_IPHONEX) {
        [self.checkInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.45);
        }];
    } else {
        [self.checkInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
        }];
    }

    if (IS_IPHONESE) {
        [self.checkInRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.checkInView).offset(13);
            make.top.equalTo(self.checkInView).offset(21);
        }];
    } else {
        [self.checkInRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.checkInView).offset(13);
            make.top.equalTo(self.checkInView).offset(31);
        }];
    }
    

    if (IS_IPHONEX) {
        [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@40);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.storeView.mas_top).offset(-28);
        }];
        self.checkInButton.layer.cornerRadius = 20;
    } else if (IS_IPHONESE)  {
        [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@35);
            make.width.equalTo(@105);
            make.bottom.equalTo(self.storeView.mas_top).offset(-20);
            self.checkInButton.layer.cornerRadius = 17.5;
        }];
    } else {
        [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@40);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.storeView.mas_top).offset(-20);
        }];
        self.checkInButton.layer.cornerRadius = 20;
    }

    if (IS_IPHONEX) {
        [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@104);
            make.bottom.equalTo(self).offset(16);       // 隐藏下圆角
        }];
    } else {
        [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@89);
            make.bottom.equalTo(self).offset(16);       // 隐藏下圆角
        }];
    }
    
    [self.dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.storeView);
        make.top.equalTo(self.storeView).offset(9);
        make.height.equalTo(@6);
        make.width.equalTo(@30);
    }];
    self.dragHintView.layer.cornerRadius = 3;
    
    [self.storeTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeView).offset(22);
        make.leading.equalTo(self.storeView).offset(13);
    }];
    
    [self.myGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.leading.equalTo(self.storeTitlelabel.mas_trailing).offset(16);
        make.height.equalTo(@26);
        make.width.equalTo(@75);
    }];
    self.myGoodsButton.layer.cornerRadius = 13;
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.storeView).offset(-16);
    }];
    
    [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.scoreLabel.mas_leading).offset(-9);
        make.height.width.equalTo(@21);
    }];
    
    if (IS_IPHONESE) {
        [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.checkInView).offset(90);
            make.leading.equalTo(self.checkInView).offset(10);
            make.height.equalTo(@21);
            make.trailing.equalTo(self.checkInView).offset(-16);
        }];
    } else {
        [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.checkInView).offset(126);
            make.leading.equalTo(self.checkInView).offset(MAIN_SCREEN_W * 0.04267);
            make.height.equalTo(@21);
            make.trailing.equalTo(self.checkInView).offset(-16);
        }];
    }
    
}

- (void)CheckInSucceded {
    [self.bar removeFromSuperview];
    CheckInBar *bar = [[CheckInBar alloc] init];
    [self.checkInView addSubview:bar];
    self.bar = bar;
    [self layoutSubviews];
    
    self.checkInRankLabel.text = [NSString stringWithFormat:@"今日第%@位打卡", [UserItemTool defaultItem].rank];
    self.checkInRankPercentLabel.hidden = NO;
    self.checkInRankPercentLabel.text = [NSString stringWithFormat:@"超过%d%%的邮子", [UserItemTool defaultItem].rank_Persent.intValue];
    self.daysLabel.text = [NSString stringWithFormat:@"已连续打卡%@天", [UserItemTool defaultItem].checkInDay];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@", [UserItemTool defaultItem].integral];
}

#pragma mark - 按钮
- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

- (void)CheckInButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(CheckInButtonClicked:)]) {
        [self.delegate CheckInButtonClicked:sender];
    }
}

- (void)myGoodsButtonTouched {
    if ([self.delegate respondsToSelector:@selector(myGoodsButtonTouched)]) {
        [self.delegate myGoodsButtonTouched];
    }
}


#pragma mark - 手势
- (void)presentIntegralStore:(UIPanGestureRecognizer *)pan {
    if ([self.delegate respondsToSelector:@selector(presentIntegralStore:)]) {
        [self.delegate presentIntegralStore:pan];
    }
}


@end
