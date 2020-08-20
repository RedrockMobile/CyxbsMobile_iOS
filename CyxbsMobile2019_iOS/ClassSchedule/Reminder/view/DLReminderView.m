//
//  DLReminderView.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/9.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLReminderView.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@implementation DLReminderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
        } else {
            self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        [self initBackButton];
        [self initTitleLabel];
        [self initNoticeLabel];
        [self initTextFiled];
        [self initNextButton];
    }
    return self;
}

- (void)initBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reminderBack"]];
    backImage.backgroundColor = [UIColor clearColor];
    [self addSubview: backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(45*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(14*kRateX);
        make.width.mas_equalTo(8*kRateX);
        make.height.mas_equalTo(15*kRateY);
    }];
    
    self.backBtn = [[UIButton alloc]init];
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self addSubview: self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(45*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(14*kRateX);
        make.width.mas_equalTo(15*kRateX);
        make.height.mas_equalTo(30*kRateY);
    }];
}

/// @”为你的行程加标题“、@”为你的行程加具体内容“
- (void)initTitleLabel{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.numberOfLines = 0;
    self.titleLab.font = [UIFont fontWithName:@".PingFang SC-Semibold" size: 34*kRateX];
    if (@available(iOS 11.0, *)) {
        self.titleLab.textColor = [UIColor colorNamed:@"titleLabelColor"];
    } else {
        self.titleLab.textColor = [UIColor colorWithHexString:@"#122D55"];
    }
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(168*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(18*kRateX);
        make.width.mas_equalTo(240*kRateX);
        make.height.mas_equalTo(100*kRateY);
    }];
}
/// 标题
- (void)initNoticeLabel{
    self.notoiceLab = [[UILabel alloc] init];
    self.notoiceLab.textAlignment = NSTextAlignmentLeft;
    self.notoiceLab.numberOfLines = 1;
    self.notoiceLab.font = [UIFont fontWithName:@".PingFang SC-Semibold" size: 15*kRateX];
    if (@available(iOS 11.0, *)) {
        self.notoiceLab.textColor = [UIColor colorNamed:@"titleLabelColor"];
    } else {
        self.notoiceLab.textColor = [UIColor colorWithHexString:@"#122D55"];
        // Fallback on earlier versions
    }
    [self addSubview:self.notoiceLab];
    [self.notoiceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLab.mas_top).mas_offset(-6*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(18*kRateX);
        make.width.mas_equalTo(200*kRateX);
        make.height.mas_equalTo(23*kRateY);
    }];
}
- (void)initTextFiled{
    self.textFiled = [[DLTextFiled alloc] init];
    [self addSubview: self.textFiled];
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).mas_offset(15*kRateY);
        make.left.equalTo(self.mas_left).mas_offset(16*kRateX);
        make.width.mas_equalTo(343*kRateX);
        make.height.mas_equalTo(55*kRateY);
    }];
}

- (void)initNextButton{
    self.nextBtn = [[DLNextButton alloc] initWithFrame:CGRectMake(77, 219, 33, 33)];
    [self addSubview: self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textFiled.mas_bottom).mas_offset(104*kRateY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(66*kRateX);
        make.height.mas_equalTo(66*kRateX);
    }];
}
- (void)layoutSubviews{
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(240*kRateX);
    }];
}
@end
