//
//  MineHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//个人主页面的tableView顶部的一大块View都是这个类，这个类会被设置成tableView的headview

#import "MineHeaderView.h"
#import <UMPush/UMessage.h>

@interface MineHeaderView ()

/// 签到按钮、动态、评论、获赞、已连续签到天数 label的背景板
@property (nonatomic, weak) UIView *whiteBoard;

@end

@implementation MineHeaderView
//MARK: - 重写的方法:
- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_W * 0.776)];
    if (self) {
        /// 添加头像
        [self addHeaderImageView];
        /// 添加昵称label
        [self addNicknameLabel];
        /// 添加显示个性签名的label
        [self addIntroductionLabel];
        /// 添加编辑资料按钮
        [self addEditButton];
        
        
        /// 添加背景板
        [self addWhiteBoard];
        /// 添加@“已连续签到x天”label
        [self addSigninDaysLabel];
        /// 添加签到按钮
        [self addSigninButton];
        /// 添加动态、评论、获赞 的   label与按钮
        [self addLabelsAndBtns];
    }
    return self;
}

// 禁止使用initWithFrame:方法，使用“init”方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"Use 'initWithFrame:'" userInfo:nil];
    }
    return self;
}

//MARK: - 添加子控件的方法：
/// 添加头像
- (void)addHeaderImageView{
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.backgroundColor = [UIColor colorWithRed:247/255.0 green:206/255.0 blue:200/255.0 alpha:1];
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
#ifdef DEBUG
    {
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
    }
#endif
}

/// 添加昵称label
- (void)addNicknameLabel{
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self addSubview:nicknameLabel];
    nicknameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    if (@available(iOS 11.0, *)) {
        nicknameLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    } else {
        nicknameLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
    }
    self.nicknameLabel = nicknameLabel;
    
}

/// 添加显示个性签名的label
- (void)addIntroductionLabel{
    UILabel *introductionLabel = [[UILabel alloc] init];
    introductionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    if (@available(iOS 11.0, *)) {
        introductionLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    } else {
        introductionLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
    }
    [self addSubview:introductionLabel];
    self.introductionLabel = introductionLabel;
}

/// 添加编辑资料按钮
- (void)addEditButton{
    UIButton *editButton = [[UIButton alloc] init];
    [self addSubview:editButton];
    self.editButton = editButton;
    
    [editButton setBackgroundImage:[UIImage imageNamed:@"Mine_edit"] forState:UIControlStateNormal];
    
    [editButton addTarget:self.delegate action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

/// 添加背景板
- (void)addWhiteBoard{
    UIView *whiteBoard = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        whiteBoard.backgroundColor = [UIColor colorNamed:@"Mine_Main_HeaderColor"];
    } else {
        whiteBoard.backgroundColor = [UIColor whiteColor];
    }
    whiteBoard.layer.cornerRadius = 16;
    [self addSubview:whiteBoard];
    self.whiteBoard = whiteBoard;
}

/// 添加@“已连续签到x天”label
- (void)addSigninDaysLabel{
    UILabel *signinDaysLabel = [[UILabel alloc] init];
    signinDaysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    if (@available(iOS 11.0, *)) {
        signinDaysLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    } else {
        signinDaysLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
    }
    [self addSubview:signinDaysLabel];
    self.signinDaysLabel = signinDaysLabel;
}

/// 添加签到按钮
- (void)addSigninButton{
    UIButton *signinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:signinButton];
    self.checkInButton = signinButton;
    
    if (@available(iOS 11.0, *)) {
        signinButton.backgroundColor = [UIColor colorNamed:@"Mine_Main_SignInButtonColor"];
    } else {
        signinButton.backgroundColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:209/255.0 alpha:1.0];
    }
    signinButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [signinButton setTitle:@"签到" forState:UIControlStateNormal];
    [signinButton setTintColor:[UIColor whiteColor]];
    
    [signinButton addTarget:self.delegate action:@selector(checkInButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

/// 添加动态、评论、获赞 的   label与按钮
- (void)addLabelsAndBtns{

    self.articleNumBtn = [self getNumBtnWithBtnName:@"动态"];
    self.remarkNumBtn = [self getNumBtnWithBtnName:@"评论"];
    self.praiseNumBtn = [self getNumBtnWithBtnName:@"获赞"];

    //代理是个人主页面的控制器
    [self.articleNumBtn addTarget:self.delegate action:@selector(articleNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.remarkNumBtn addTarget:self.delegate action:@selector(remarkNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseNumBtn addTarget:self.delegate action:@selector(praiseNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}

//MARK: - 其他方法:
- (MainPageNumBtn*)getNumBtnWithBtnName:(NSString*)btnNameStr{
    MainPageNumBtn *numBtn = [[MainPageNumBtn alloc] init];
    [self addSubview:numBtn];
    numBtn.btnNameLabel.text = btnNameStr;
    return numBtn;
}
//MARK: - 添加约束的方法:
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
        make.leading.equalTo(self.whiteBoard).offset(15.5);
        make.top.equalTo(self.whiteBoard).offset(21);
    }];
    
    [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.signinDaysLabel);
        make.trailing.equalTo(self.whiteBoard).offset(-14);
        make.height.equalTo(@28);
        make.width.equalTo(@52);
    }];
    self.checkInButton.layer.cornerRadius = 14;
    
    int h;
    if (IS_IPHONESE) {
        h = 43;
    } else {
        h = 53;
    }
    
    [self.articleNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
        make.leading.equalTo(self.whiteBoard).offset(0.1341*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoard).offset(h);
    }];

    [self.remarkNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
        make.centerX.equalTo(self.whiteBoard);
        make.top.equalTo(self.articleNumBtn);
    }];

    [self.praiseNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
        make.right.equalTo(self.whiteBoard).offset(-0.1341*SCREEN_WIDTH);
        make.top.equalTo(self.articleNumBtn);
    }];
    
    
    
}

@end
