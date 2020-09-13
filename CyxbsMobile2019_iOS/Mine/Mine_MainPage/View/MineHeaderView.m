//
//  MineHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineHeaderView.h"
#import "MineQADataItem.h"
#import <UMPush/UMessage.h>

@interface MineHeaderView ()

@property (nonatomic, weak) UIView *whiteBoard;
@property (nonatomic, weak) UILabel *questionLabel;
@property (nonatomic, weak) UILabel *answerLabel;
@property (nonatomic, weak) UILabel *responseLabel;
@property (nonatomic, weak) UILabel *praiseLabel;

@end

@implementation MineHeaderView


#pragma mark - 添加子控件
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.backgroundColor = [UIColor colorWithRed:247/255.0 green:206/255.0 blue:200/255.0 alpha:1];
        [self addSubview:headerImageView];
        self.headerImageView = headerImageView;
        
#ifdef DEBUG
        headerImageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            NSString *deviceToken = [UserDefaultTool valueWithKey:kUMDeviceToken];
            if (deviceToken) {
                UIAlertController *deviceTokenAlert = [UIAlertController alertControllerWithTitle:@"deviceToken" message:deviceToken preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = deviceToken;
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [deviceTokenAlert addAction:copyAction];
                [deviceTokenAlert addAction:cancelAction];
                
                [self.viewController presentViewController:deviceTokenAlert animated:YES completion:nil];
            }
        }];
        [self.headerImageView addGestureRecognizer:longTap];
#endif

        UILabel *nicknameLabel = [[UILabel alloc] init];
        [self addSubview:nicknameLabel];
        nicknameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (@available(iOS 11.0, *)) {
            nicknameLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
        } else {
            nicknameLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        }
        self.nicknameLabel = nicknameLabel;
        
        UILabel *introductionLabel = [[UILabel alloc] init];
        introductionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (@available(iOS 11.0, *)) {
            introductionLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
        } else {
            introductionLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        }
        [self addSubview:introductionLabel];
        self.introductionLabel = introductionLabel;
        
        UIButton *editButton = [[UIButton alloc] init];
        [editButton setBackgroundImage:[UIImage imageNamed:@"Mine_edit"] forState:UIControlStateNormal];
        [self addSubview:editButton];
        self.editButton = editButton;
        
        UIView *whiteBoard = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            whiteBoard.backgroundColor = [UIColor colorNamed:@"Mine_Main_HeaderColor"];
        } else {
            whiteBoard.backgroundColor = [UIColor whiteColor];
        }
        whiteBoard.layer.cornerRadius = 16;
        [self addSubview:whiteBoard];
        self.whiteBoard = whiteBoard;
        
        UILabel *signinDaysLabel = [[UILabel alloc] init];
        signinDaysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        if (@available(iOS 11.0, *)) {
            signinDaysLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
        } else {
            signinDaysLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
        }
        [self addSubview:signinDaysLabel];
        self.signinDaysLabel = signinDaysLabel;
        
        UIButton *signinButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (@available(iOS 11.0, *)) {
            signinButton.backgroundColor = [UIColor colorNamed:@"Mine_Main_SignInButtonColor"];
        } else {
            signinButton.backgroundColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:209/255.0 alpha:1.0];
        }
        signinButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [signinButton setTitle:@"签到" forState:UIControlStateNormal];
        [signinButton setTintColor:[UIColor whiteColor]];
        [self addSubview:signinButton];
        self.signinButton = signinButton;
        
        
        MineQADataItem *item = [NSKeyedUnarchiver unarchiveObjectWithFile:[MineQADataItem archivePath]];
        
        UILabel *questionNumberLabel = [[UILabel alloc] init];
        if (IS_IPHONESE) {
            questionNumberLabel.font = [UIFont fontWithName:@"Impact" size:25];
        } else {
            questionNumberLabel.font = [UIFont fontWithName:@"Impact" size:35];
        }
        if (@available(iOS 11.0, *)) {
            questionNumberLabel.textColor = [UIColor colorNamed:@"Mine_Main_QANumberLabelColor"];
        } else {
            questionNumberLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        questionNumberLabel.textAlignment = NSTextAlignmentCenter;
        questionNumberLabel.userInteractionEnabled = YES;
        questionNumberLabel.text = item ? [NSString stringWithFormat:@"%@", item.askNum] : @"";
        [self addSubview:questionNumberLabel];
        self.questionsNumberLabel = questionNumberLabel;
        
        UILabel *answerNumberLabel = [[UILabel alloc] init];
        if (IS_IPHONESE) {
            answerNumberLabel.font = [UIFont fontWithName:@"Impact" size:25];
        } else {
            answerNumberLabel.font = [UIFont fontWithName:@"Impact" size:35];
        }
        if (@available(iOS 11.0, *)) {
            answerNumberLabel.textColor = [UIColor colorNamed:@"Mine_Main_QANumberLabelColor"];
        } else {
            answerNumberLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        answerNumberLabel.textAlignment = NSTextAlignmentCenter;
        answerNumberLabel.userInteractionEnabled = YES;
        answerNumberLabel.text = item ? [NSString stringWithFormat:@"%@", item.answerNum] : @"";
        [self addSubview:answerNumberLabel];
        self.answerNumberLabel = answerNumberLabel;
        
        UILabel *responseNumberLabel = [[UILabel alloc] init];
        if (IS_IPHONESE) {
            responseNumberLabel.font = [UIFont fontWithName:@"Impact" size:25];
        } else {
            responseNumberLabel.font = [UIFont fontWithName:@"Impact" size:35];
        }
        if (@available(iOS 11.0, *)) {
            responseNumberLabel.textColor = [UIColor colorNamed:@"Mine_Main_QANumberLabelColor"];
        } else {
            responseNumberLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        responseNumberLabel.textAlignment = NSTextAlignmentCenter;
        responseNumberLabel.userInteractionEnabled = YES;
        responseNumberLabel.text = item ? [NSString stringWithFormat:@"%@", item.commentNum] : @"";
        [self addSubview:responseNumberLabel];
        self.responseNumberLabel = responseNumberLabel;
        
        UILabel *praiseNumberLabel = [[UILabel alloc] init];
        if (IS_IPHONESE) {
            praiseNumberLabel.font = [UIFont fontWithName:@"Impact" size:25];
        } else {
            praiseNumberLabel.font = [UIFont fontWithName:@"Impact" size:35];
        }
        if (@available(iOS 11.0, *)) {
            praiseNumberLabel.textColor = [UIColor colorNamed:@"Mine_Main_QANumberLabelColor"];
        } else {
            praiseNumberLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        praiseNumberLabel.textAlignment = NSTextAlignmentCenter;
        praiseNumberLabel.text = item ? [NSString stringWithFormat:@"%@", item.praiseNum] : @"";
        [self addSubview:praiseNumberLabel];
        self.praiseNumberLabel = praiseNumberLabel;
        
        UILabel *questionLabel = [[UILabel alloc] init];
        questionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (@available(iOS 11.0, *)) {
            questionLabel.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
        } else {
            questionLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        questionLabel.text = @"提问";
        [self addSubview:questionLabel];
        self.questionLabel = questionLabel;
        
        UILabel *answerLabel = [[UILabel alloc] init];
        answerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (@available(iOS 11.0, *)) {
            answerLabel.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
        } else {
            answerLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }        answerLabel.text = @"回答";
        [self addSubview:answerLabel];
        self.answerLabel = answerLabel;
        
        UILabel *responseLabel = [[UILabel alloc] init];
        responseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (@available(iOS 11.0, *)) {
            responseLabel.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
        } else {
            responseLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }        responseLabel.text = @"评论";
        [self addSubview:responseLabel];
        self.responseLabel = responseLabel;
        
        UILabel *praiseLabel = [[UILabel alloc] init];
        praiseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        if (@available(iOS 11.0, *)) {
            praiseLabel.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
        } else {
            praiseLabel.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
        }
        praiseLabel.text = @"获赞";
        [self addSubview:praiseLabel];
        self.praiseLabel = praiseLabel;
    }
    return self;
}

// 禁止使用init方法，使用“initWithFrame:”方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"Use 'initWithFrame:'" userInfo:nil];
    }
    return self;
}


#pragma mark - 添加约束
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    // 所有的约束均根据屏幕的长宽比例与控件所占的比例来计算
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(MAIN_SCREEN_W * 0.042);
        make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_W * 0.16);
        make.height.width.equalTo(@(MAIN_SCREEN_W * 0.1733));
    }];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = MAIN_SCREEN_W * 0.1733 * 0.5;
    
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
        make.trailing.equalTo(self).offset(-MAIN_SCREEN_W * 0.0437);
        make.height.width.equalTo(@24);
    }];
    
    [self.whiteBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(20);
        make.height.equalTo(@(MAIN_SCREEN_W * 0.336));
        make.width.equalTo(@(MAIN_SCREEN_W * 0.912));
    }];
    
    [self.signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.whiteBoard).offset(14);
        make.top.equalTo(self.whiteBoard).offset(16);
    }];
    
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.signinDaysLabel);
        make.trailing.equalTo(self.whiteBoard).offset(-14);
        make.top.equalTo(self.whiteBoard).offset(13);
        make.height.equalTo(@28);
        make.width.equalTo(@52);
    }];
    self.signinButton.layer.cornerRadius = 14;
    
    int interval = (MAIN_SCREEN_W * 0.912 - MAIN_SCREEN_W * 0.12 * 4 - 30) / 3.0;
    if (IS_IPHONESE) {
        [self.questionsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.whiteBoard).offset(15);
            make.top.equalTo(self.whiteBoard).offset(43);
        }];
        
        [self.answerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.questionsNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];
        
        [self.responseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.answerNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];

        [self.praiseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.responseNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];
    } else {
        [self.questionsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.whiteBoard).offset(15);
            make.top.equalTo(self.whiteBoard).offset(53);
        }];
        
        [self.answerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.questionsNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];
        
        [self.responseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.answerNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];
        
        [self.praiseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
            make.leading.equalTo(self.responseNumberLabel.mas_trailing).offset(interval);
            make.top.equalTo(self.questionsNumberLabel);
        }];
    }
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.questionsNumberLabel);
        make.top.equalTo(self.questionsNumberLabel.mas_bottom);
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.answerNumberLabel);
        make.top.equalTo(self.answerNumberLabel.mas_bottom);
    }];
    
    [self.responseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.responseNumberLabel);
        make.top.equalTo(self.responseNumberLabel.mas_bottom);
    }];
    
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.praiseNumberLabel);
        make.top.equalTo(self.praiseNumberLabel.mas_bottom);
    }];
}

@end
