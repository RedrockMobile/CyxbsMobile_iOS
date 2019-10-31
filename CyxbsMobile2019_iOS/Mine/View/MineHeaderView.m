//
//  MineHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, weak) UIView *whiteBoard;
@property (nonatomic, weak) UILabel *questionLabel;
@property (nonatomic, weak) UILabel *answerLabel;
@property (nonatomic, weak) UILabel *responseLabel;
@property (nonatomic, weak) UILabel *praiseLabel;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.backgroundColor = [UIColor colorWithRed:247/255.0 green:206/255.0 blue:200/255.0 alpha:1];
        [self addSubview:headerImageView];
        self.headerImageView = headerImageView;
        
        UILabel *nicknameLabel = [[UILabel alloc] init];
        [self addSubview:nicknameLabel];
        nicknameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        nicknameLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        self.nicknameLabel = nicknameLabel;
        
        UILabel *introductionLabel = [[UILabel alloc] init];
        introductionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        introductionLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        [self addSubview:introductionLabel];
        self.introductionLabel = introductionLabel;
        
        UIButton *editButton = [[UIButton alloc] init];
        [self addSubview:editButton];
        self.editButton = editButton;
        
        UIView *whiteBoard = [[UIView alloc] init];
        whiteBoard.backgroundColor = [UIColor whiteColor];
        whiteBoard.layer.cornerRadius = 16;
        [self addSubview:whiteBoard];
        self.whiteBoard = whiteBoard;
        
        UILabel *signinDaysLabel = [[UILabel alloc] init];
        signinDaysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        signinDaysLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        [self addSubview:signinDaysLabel];
        self.signinDaysLabel = signinDaysLabel;
        
        UIButton *signinButton = [[UIButton alloc] init];
        [self addSubview:signinButton];
        self.signinButton = signinButton;
        
        UILabel *questionNumberLabel = [[UILabel alloc] init];
        [self addSubview:questionNumberLabel];
        self.questionsNumberLabel = questionNumberLabel;
        
        UILabel *answerNumberLabel = [[UILabel alloc] init];
        [self addSubview:answerNumberLabel];
        self.answerNumberLabel = answerNumberLabel;
        
        UILabel *responseNumberLabel = [[UILabel alloc] init];
        [self addSubview:responseNumberLabel];
        self.responseNumberLabel = responseNumberLabel;
        
        UILabel *praiseNumberLabel = [[UILabel alloc] init];
        [self addSubview:praiseNumberLabel];
        self.praiseNumberLabel = praiseNumberLabel;
        
        UILabel *questionLabel = [[UILabel alloc] init];
        [self addSubview:questionLabel];
        self.questionLabel = questionLabel;
        
        UILabel *answerLabel = [[UILabel alloc] init];
        [self addSubview:answerLabel];
        self.answerLabel = answerLabel;
        
        UILabel *responseLabel = [[UILabel alloc] init];
        [self addSubview:responseLabel];
        self.responseLabel = responseLabel;
        
        UILabel *praiseLabel = [[UILabel alloc] init];
        [self addSubview:praiseLabel];
        self.praiseLabel = praiseLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(16);
        make.top.equalTo(self.mas_top).offset(80);
        make.height.width.equalTo(@65);
    }];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = 32.5;
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(20);
        make.top.equalTo(self.headerImageView).offset(8);
    }];
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView);
        make.trailing.equalTo(self).offset(-16);
        make.height.width.equalTo(@24);
    }];
    
    [self.whiteBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(20);
        make.height.equalTo(@126);
        make.width.equalTo(@342);
    }];
    
    [self.signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.whiteBoard).offset(14);
        make.top.equalTo(self.whiteBoard).offset(16);
    }];
}

@end
