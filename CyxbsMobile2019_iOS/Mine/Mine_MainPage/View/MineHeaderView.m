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

/// 昵称label和个性签名label的背景label
@property (nonatomic, strong) UIView *backView;
@end

@implementation MineHeaderView
//MARK: - 重写的方法:
- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 281.25* HScaleRate_SE)];
    if (self) {
        /// 添加头像
        [self addHeaderImageBtn];
        /// 添加昵称label、显示个性签名的label
        [self addBackview];
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
//        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
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
- (void)addHeaderImageBtn{
    UIButton *btn = [[UIButton alloc] init];
    self.headerImageBtn = btn;
    [btn addTarget:self.delegate action:@selector(headImgClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)addBackview {
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    self.backView = backView;
//    backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    //++++++++++++++++++添加昵称label++++++++++++++++++++  Begain
    UILabel *nicknameLabel = [[UILabel alloc] init];
    [backView addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;
    nicknameLabel.font = [UIFont fontWithName:PingFangSCSemibold size:21*fontSizeScaleRate_SE];
    if (@available(iOS 11.0, *)) {
        nicknameLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    } else {
        nicknameLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
    }
    
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView);
    }];
    //++++++++++++++++++添加昵称label++++++++++++++++++++  End
    
    
    
    
    
    
    //++++++++++++++++++添加显示个性签名的label++++++++++++++++++++  Begain
    UILabel *introductionLabel = [[UILabel alloc] init];
    [backView addSubview:introductionLabel];
    self.introductionLabel = introductionLabel;
    introductionLabel.font = [UIFont fontWithName:PingFangSCSemibold size:11*fontSizeScaleRate_SE];
    if (@available(iOS 11.0, *)) {
        introductionLabel.textColor = [UIColor colorNamed:@"Mine_Main_TitleColor"];
    } else {
        introductionLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1];
    }
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(backView);
        make.top.equalTo(nicknameLabel.mas_bottom).offset(0.006*SCREEN_HEIGHT);
        make.right.equalTo(self).offset(-0.05*SCREEN_WIDTH);
    }];
    //++++++++++++++++++添加显示个性签名的label++++++++++++++++++++  End
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
    whiteBoard.layer.cornerRadius = 10;
    [self addSubview:whiteBoard];
    self.whiteBoard = whiteBoard;
}

/// 添加@“已连续签到x天”label
- (void)addSigninDaysLabel{
    UILabel *signinDaysLabel = [[UILabel alloc] init];
    signinDaysLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15*fontSizeScaleRate_SE];
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
    
    //夜间和白天两种颜色一样
    
    
    if (IS_IPHONEX) {
        signinButton.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
    }else {
        signinButton.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:13];
    }
    
    
    [signinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [signinButton addTarget:self.delegate action:@selector(checkInButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *lastCheckInDate = [[NSUserDefaults standardUserDefaults] valueForKey:MineLastCheckInTime_NSDate];
    
    NSString *title;
    UIColor *color;
    if (lastCheckInDate!=nil&&[lastCheckInDate isToday]) {
        title = @"已签到";
        color = RGBColor(225, 223, 224, 1);
    }else {
        title = @"签到";
        color = [UIColor colorWithRed:63/255.0 green:64/255.0 blue:225/255.0 alpha:1.0];
    }
    
    //4.Code Expression:函数或方法内部:定义名字，访问属性，访问成员变量 时都会出现
    [signinButton setTitle:title forState:UIControlStateNormal];
    signinButton.backgroundColor = color;
}

/// 添加动态、评论、获赞 的   label与按钮
- (void)addLabelsAndBtns{
    self.articleNumBtn = [self getNumBtnWithBtnName:@"动态" titleCntDefaultKey:MineDynamicCntStrKey];
    self.remarkNumBtn = [self getNumBtnWithBtnName:@"评论" titleCntDefaultKey:MineCommentCntStrKey];
    self.praiseNumBtn = [self getNumBtnWithBtnName:@"获赞" titleCntDefaultKey:MinePraiseCntStrKey];

    //代理是个人主页面的控制器
    [self.articleNumBtn addTarget:self.delegate action:@selector(articleNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.remarkNumBtn addTarget:self.delegate action:@selector(remarkNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseNumBtn addTarget:self.delegate action:@selector(praiseNumBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}

//MARK: - 其他方法:
- (MainPageNumBtn*)getNumBtnWithBtnName:(NSString*)btnNameStr titleCntDefaultKey:(NSString*)key{
    MainPageNumBtn *numBtn = [[MainPageNumBtn alloc] init];
    [self addSubview:numBtn];
    
    //按钮标题，用来显示动态/评论/获赞的总数
    [numBtn setTitle:[[NSUserDefaults standardUserDefaults] stringForKey:key] forState:UIControlStateNormal];
    
    //按钮的名字
    numBtn.btnNameLabel.text = btnNameStr;
    return numBtn;
}
//MARK: - 添加约束的方法:
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 所有的约束均根据屏幕的长宽比例与控件所占的比例来计算
    [self.headerImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(MAIN_SCREEN_W * 0.0413);
        make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_H * 0.0652);
        make.height.width.equalTo(@(MAIN_SCREEN_W * 0.1733));
    }];
    self.headerImageBtn.clipsToBounds = YES;
    self.headerImageBtn.layer.cornerRadius = MAIN_SCREEN_W * 0.1733 * 0.5;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageBtn.mas_trailing).offset(0.052*SCREEN_WIDTH);
        make.width.mas_equalTo(0.6*SCREEN_WIDTH);
        make.centerY.equalTo(self.headerImageBtn);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(MAIN_SCREEN_W * 0.0387);
        make.width.mas_equalTo(0.0453*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.048*MAIN_SCREEN_W);
    }];
    
    [self.whiteBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageBtn);
        make.top.equalTo(self.headerImageBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(126*HScaleRate_SE);
        make.width.equalTo(@(MAIN_SCREEN_W * 0.912));
    }];
    
    [self.signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.whiteBoard).offset(15.5);
        make.top.equalTo(self.whiteBoard).offset(21);
    }];
    
    [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.signinDaysLabel);
        make.trailing.equalTo(self.whiteBoard).offset(-14);
        make.height.mas_equalTo(0.07467*SCREEN_WIDTH);
        make.width.mas_equalTo(0.1387*SCREEN_WIDTH);
    }];
    
    self.checkInButton.layer.cornerRadius = 0.037335*SCREEN_WIDTH;
    //126
    
    [self.articleNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBoard).offset(-0.295*SCREEN_WIDTH);
        make.top.equalTo(self.whiteBoard).offset(53*HScaleRate_SE);
    }];

    [self.remarkNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBoard);
        make.top.equalTo(self.articleNumBtn);
    }];

    [self.praiseNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBoard).offset(0.295*SCREEN_WIDTH);
        make.top.equalTo(self.articleNumBtn);
    }];
}

@end



//#ifdef DEBUG
//    {
//        headerImageBtn.userInteractionEnabled = YES;
//        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//
//            NSString *deviceToken = [UserDefaultTool valueWithKey:kUMDeviceToken];
//            if (deviceToken) {
//                UIAlertController *deviceTokenAlert = [UIAlertController alertControllerWithTitle:@"deviceToken" message:deviceToken preferredStyle:UIAlertControllerStyleAlert];
//
//
//                UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                    pasteboard.string = deviceToken;
//                }];
//
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//                [deviceTokenAlert addAction:copyAction];
//                [deviceTokenAlert addAction:cancelAction];
//
//                [self.viewController presentViewController:deviceTokenAlert animated:YES completion:nil];
//            }
//        }];
//        [self.headerImageBtn addGestureRecognizer:longTap];
//    }
//#endif
