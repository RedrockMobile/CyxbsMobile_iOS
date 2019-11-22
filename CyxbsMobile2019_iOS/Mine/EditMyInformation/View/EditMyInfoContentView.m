//
//  EditMyInfoContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoContentView.h"

#define LABELCOLOR [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]
#define PLACEHOLDERCOLOR [UIColor colorWithRed:154/255.0 green:165/255.0 blue:181/255.0 alpha:1]
#define SAVEBUTTONCOLOR [UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1]

#define LABELFONT [UIFont fontWithName:@"PingFangSC-Semibold" size:15]
#define PLACEHOLDERFONT [UIFont fontWithName:@"PingFangSC-Regular" size:15]

/**
 @property (nonatomic, weak) UIImageView *headerImageView;
 @property (nonatomic, weak) MineEditTextField *nicknameTextField;
 @property (nonatomic, weak) MineEditTextField *introductionTextField;
 @property (nonatomic, weak) MineEditTextField *QQTextField;
 @property (nonatomic, weak) MineEditTextField *phoneNumberTextField;
 @property (nonatomic, weak) UIButton *academyButton;

 @property (nonatomic, weak) UIButton *saveButton;
 */

@interface EditMyInfoContentView ()

@property (nonatomic, weak) UIButton *whatsThisButton;
@property (nonatomic, weak) UILabel *nicknameLabel;
@property (nonatomic, weak) UILabel *introductionLabel;
@property (nonatomic, weak) UILabel *QQLabel;
@property (nonatomic, weak) UILabel *phoneNumberLabel;
@property (nonatomic, weak) UILabel *academyLabel;
@property (nonatomic, weak) UILabel *explainLabel;

@end

@implementation EditMyInfoContentView

#pragma mark - 添加子控件
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 16;
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        scrollView.showsVerticalScrollIndicator = NO;
        self.contentScrollView = scrollView;
        
        UIView *gestureView = [[UIView alloc] init];
        gestureView.backgroundColor = UIColor.clearColor;
        [self.contentScrollView addSubview:gestureView];
        self.gestureView = gestureView;
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [self.contentScrollView addSubview:headerImageView];
        self.headerImageView = headerImageView;
        NSString *headImgUrl_str = [UserItemTool defaultItem].headImgUrl;
        NSURL *headImageUrl = [NSURL URLWithString:headImgUrl_str];
        [headerImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageFromCacheOnly context:nil progress:nil completed:nil];
        
        UIButton *whatsThisButton = [[UIButton alloc] init];
        whatsThisButton.backgroundColor = PLACEHOLDERCOLOR;
        [self.contentScrollView addSubview:whatsThisButton];
        self.whatsThisButton = whatsThisButton;
        
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.text = @"昵称";
        nicknameLabel.textColor = LABELCOLOR;
        nicknameLabel.font = LABELFONT;
        [self.contentScrollView addSubview:nicknameLabel];
        self.nicknameLabel = nicknameLabel;
        
        MineEditTextField *nicknameTextField = [[MineEditTextField alloc] init];
        NSString *oldNickname = [UserItemTool defaultItem].nickname;
        if (!oldNickname || ![oldNickname isEqualToString:@""]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldNickname attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            nicknameTextField.attributedPlaceholder = string;
        } else {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            nicknameTextField.attributedPlaceholder = string;
        }
        [self.contentScrollView addSubview:nicknameTextField];
        self.nicknameTextField = nicknameTextField;
        
        UILabel *introductionLabel = [[UILabel alloc] init];
        introductionLabel.text = @"个性签名";
        introductionLabel.textColor = LABELCOLOR;
        introductionLabel.font = LABELFONT;
        [self.contentScrollView addSubview:introductionLabel];
        self.introductionLabel = introductionLabel;
        
        MineEditTextField *introductionField = [[MineEditTextField alloc] init];
        NSString *oldIntroduction = [UserItemTool defaultItem].introduction;
        if (!oldIntroduction || ![oldIntroduction isEqualToString:@""]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldIntroduction attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            introductionField.attributedPlaceholder = string;
        } else {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            introductionField.attributedPlaceholder = string;
        }
        [self.contentScrollView addSubview:introductionField];
        self.introductionTextField = introductionField;
        
        UILabel *QQLabel = [[UILabel alloc] init];
        QQLabel.text = @"QQ";
        QQLabel.textColor = LABELCOLOR;
        QQLabel.font = LABELFONT;
        [self.contentScrollView addSubview:QQLabel];
        self.QQLabel = QQLabel;
        
        MineEditTextField *QQTextField = [[MineEditTextField alloc] init];
        NSString *oldQQ = [UserItemTool defaultItem].qq;
        if (!oldQQ || ![oldQQ isEqualToString:@""]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldQQ attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            QQTextField.attributedPlaceholder = string;
        } else {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            QQTextField.attributedPlaceholder = string;
        }
        [self.contentScrollView addSubview:QQTextField];
        self.QQTextField = QQTextField;
        
        UILabel *phoneNumberLabel = [[UILabel alloc] init];
        phoneNumberLabel.text = @"电话";
        phoneNumberLabel.textColor = LABELCOLOR;
        phoneNumberLabel.font = LABELFONT;
        [self.contentScrollView addSubview:phoneNumberLabel];
        self.phoneNumberLabel = phoneNumberLabel;
        
        MineEditTextField *phoneNumberTextField = [[MineEditTextField alloc] init];
        NSString *oldPhoneNumber = [UserItemTool defaultItem].phone;
        if (!oldPhoneNumber || ![oldPhoneNumber isEqualToString:@""]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldPhoneNumber attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            phoneNumberTextField.attributedPlaceholder = string;
        } else {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
            phoneNumberTextField.attributedPlaceholder = string;
        }
        [self.contentScrollView addSubview:phoneNumberTextField];
        self.phoneNumberTextField = phoneNumberTextField;
        
        UILabel *academyLabel = [[UILabel alloc] init];
        academyLabel.text = @"学院";
        academyLabel.textColor = LABELCOLOR;
        academyLabel.font = LABELFONT;
        [self.contentScrollView addSubview:academyLabel];
        self.academyLabel = academyLabel;
        
        UIButton *academyButton = [[UIButton alloc] init];
        [academyButton setTitle:@"选择学院" forState:UIControlStateNormal];
        [academyButton setTintColor:LABELCOLOR];
        academyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self.contentScrollView addSubview:academyButton];
        self.academyButton = academyButton;
        
        UILabel *explainLabel = [[UILabel alloc] init];
        explainLabel.text = @"写下你的联系方式，便于我们与您联系";
        explainLabel.textColor = [UIColor colorWithRed:188/255.0 green:195/255.0 blue:206/255.0 alpha:1];
        explainLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self.contentScrollView addSubview:explainLabel];
        self.explainLabel = explainLabel;
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        saveButton.backgroundColor = SAVEBUTTONCOLOR;
        [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:saveButton];
        self.saveButton = saveButton;
    }
    
    return self;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"use 'initWithFrame:'" userInfo:nil];
//    }
//    return self;
//}


#pragma mark - 添加约束
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView);
        make.leading.equalTo(self.headerImageView.mas_trailing);
        make.trailing.equalTo(self.whatsThisButton.mas_leading);
        make.bottom.equalTo(self.nicknameTextField.mas_top);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentScrollView).offset(16);
        make.height.width.equalTo(self.mas_width).multipliedBy(0.19);
    }];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.width * 0.19 * 0.5;

    [self.whatsThisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView);
        make.trailing.equalTo(self).offset(-18);
        make.height.width.equalTo(@20);
    }];

    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(18);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(34);
    }];

    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];

    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.nicknameTextField.mas_bottom).offset(30);
    }];

    [self.introductionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.introductionLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];

    [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.introductionTextField.mas_bottom).offset(30);
    }];

    [self.QQTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.QQLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];

    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.QQTextField.mas_bottom).offset(30);
    }];

    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.phoneNumberLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];

    [self.academyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(30);
    }];

    [self.academyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.academyLabel);
        make.trailing.equalTo(self).offset(-18);
        make.height.equalTo(@22);
        make.width.equalTo(@65);
    }];

    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.academyButton.mas_bottom).offset(20);
        make.trailing.equalTo(self.academyButton);
    }];

    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.explainLabel.mas_bottom).offset(32);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
    }];
    self.saveButton.layer.cornerRadius = 20;
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.height.equalTo(self);
        make.bottom.equalTo(self.saveButton).offset(52);
    }];
}


#pragma mark - 按钮调用
- (void)saveButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(saveButtonClicked:)]) {
        [self.delegate saveButtonClicked:sender];
    }
}

@end
