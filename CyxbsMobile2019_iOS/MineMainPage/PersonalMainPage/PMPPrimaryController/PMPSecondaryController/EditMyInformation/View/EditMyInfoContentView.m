//
//  EditMyInfoContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Modified by Edioth on 2021/10/12
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoContentView.h"
#import "RemindHUD.h"

#define LABELCOLOR [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]

#define LABELFONT [UIFont fontWithName:PingFangSCSemibold size:15]
#define PLACEHOLDERFONT [UIFont fontWithName:PingFangSCRegular size:15]

/**
 @property (nonatomic, weak) UIImageView *headerImageView;
 @property (nonatomic, weak) MineEditTextField *nicknameTextField;
 @property (nonatomic, weak) MineEditTextField *introductionTextField;
 @property (nonatomic, weak) MineEditTextField *QQTextField;
 @property (nonatomic, weak) MineEditTextField *phoneNumberTextField;
 @property (nonatomic, weak) UIButton *myAcademyLabel;
 
 @property (nonatomic, weak) UIButton *saveButton;
 */

@interface EditMyInfoContentView () <
UITextFieldDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
PMPPickerViewDelegate,
PMPDatePickerDelegate
>

@property (nonatomic, weak) UIButton *introductionButton;
@property (nonatomic, weak) UILabel *realNameLabel;
@property (nonatomic, weak) UILabel *stuNumLabel;
@property (nonatomic, weak) UILabel *genderLabel;
@property (nonatomic, weak) UILabel *collegeLabel;
@property (nonatomic, weak) UILabel *QQLabel;
@property (nonatomic, weak) UILabel *phoneNumberLabel;
@property (nonatomic, weak) UILabel *academyLabel;
@property (nonatomic, weak) UILabel *explainLabel;

@property (nonatomic, strong) PMPPickerView * genderPickerView;
@property (nonatomic, strong) NSArray <NSString *> * genderAry;

@property (nonatomic, strong) PMPDatePicker * birthdayDatePicker;

@end

@implementation EditMyInfoContentView

#pragma mark - 添加子控件
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addContentScrollView];
    }
    return self;
}

- (void)addContentScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor =
    [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
    self.contentScrollView = scrollView;
    [self addHeaderImageView];
    [self addIntroductionButton];
    [self addRealNameLabel];
    [self addRealNameTextField];
    [self addStuNumLabel];
    [self addStuNumTextField];
    [self addGenderLabel];
    [self addGenderTextField];
    [self addCollegeLabel ];
    [self addCollegeTextField];
    [self addQQLabel];
    [self addQQTextField];
    [self addPhoneNumberLabel];
    [self addPhoneNumberTextField];
//    [self addAcademyLabel];
//    [self addMyAcademyLabel];
//    [self addExplainLabel];
//    [self addSaveButton];
    //----
//    [self addSubview:self.genderPickerView];
//    self.genderPickerView.hidden = YES;
//    
//    [self addSubview:self.birthdayDatePicker];
//    self.birthdayDatePicker.hidden = YES;
}

- (void)addGestureView{
    UIView *gestureView = [[UIView alloc] init];
    gestureView.backgroundColor = UIColor.clearColor;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(slideToDismiss:)];
    [gestureView addGestureRecognizer:panGesture];
    [self.contentScrollView addSubview:gestureView];
    self.gestureView = gestureView;
}

- (void)addHeaderImageView {
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [self.contentScrollView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    NSString *headImgUrl_str = [UserItemTool defaultItem].headImgUrl;
    NSURL *headImageUrl = [NSURL URLWithString:headImgUrl_str];
    [headerImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageFromCacheOnly context:nil progress:nil completed:nil];
    headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageTapped:)];
    [headerImageView addGestureRecognizer:tap];
}

- (void)addIntroductionButton{
    UIButton *introductionButton = [[UIButton alloc] init];
    [introductionButton setImage:[UIImage imageNamed:@"编辑资料的点"] forState:UIControlStateNormal];
    [introductionButton addTarget:self action:@selector(showUserInformationIntroduction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:introductionButton];
    self.introductionButton = introductionButton;
}

- (void)addRealNameLabel{
    UILabel *realNameLabel = [[UILabel alloc] init];
    realNameLabel.text = @"姓名";
    
    realNameLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    
    realNameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentScrollView addSubview:realNameLabel];
    self.realNameLabel = realNameLabel;
}

- (void)addRealNameTextField{
    MineEditTextField *realNameTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:realNameTextField];
    self.realNameTextField = realNameTextField;
    realNameTextField.text = [UserItemTool defaultItem].realName;
}

- (void)addStuNumLabel{
    UILabel *stuNumLabel = [[UILabel alloc] init];
    stuNumLabel.text = @"学号";
    stuNumLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    stuNumLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentScrollView addSubview:stuNumLabel];
    self.stuNumLabel = stuNumLabel;
}

- (void)addStuNumTextField{
    MineEditTextField *introductionField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:introductionField];
    self.introductionTextField = introductionField;
    introductionField.text = [UserItemTool defaultItem].stuNum;
}

//- (void)addIntroductionLabel{
//    UILabel *introductionLabel = [[UILabel alloc] init];
//    introductionLabel.text = @"个性签名(0/20)";
//    introductionLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
//    introductionLabel.font = LABELFONT;
//    [self.contentScrollView addSubview:introductionLabel];
//    self.introductionLabel = introductionLabel;
//}
//
//- (void)addIntroductionTextField{
//    MineEditTextField *introductionField = [[MineEditTextField alloc] init];
//    [self.contentScrollView addSubview:introductionField];
//    self.introductionTextField = introductionField;
//    
//    introductionField.delegate = self;
//    
//    NSString *oldIntroduction = [UserItemTool defaultItem].introduction;
//    if (oldIntroduction==nil || [oldIntroduction isEqualToString:@""]) {
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        introductionField.attributedPlaceholder = string;
//    } else {
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldIntroduction attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        introductionField.attributedPlaceholder = string;
//        
//    }
//    [self.introductionTextField addTarget:self
//                                   action:@selector(textFieldDidChange:)
//                         forControlEvents:UIControlEventEditingChanged];
//}

/// 性别

- (void)addGenderLabel {
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.text = @"性别";
    genderLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    genderLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentScrollView addSubview:genderLabel];
    self.genderLabel = genderLabel;
}

- (void)addGenderTextField {
    MineEditTextField *genderTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:genderTextField];
    self.genderTextField = genderTextField;
    genderTextField.text = [UserItemTool defaultItem].gender;
//    genderTextField.delegate = self;
//    
//    NSString *oldGender = [UserItemTool defaultItem].gender;
//    if (oldGender==nil || [oldGender isEqualToString:@""]) {
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请选择性别" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        genderTextField.attributedPlaceholder = string;
//    } else {
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldGender attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        genderTextField.attributedPlaceholder = string;
//        
//    }
}

///学院

- (void)addCollegeLabel {
    UILabel *collegeLabel = [[UILabel alloc] init];
    collegeLabel.text = @"学院";
    collegeLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
    collegeLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentScrollView addSubview:collegeLabel];
    self.collegeLabel = collegeLabel;
}

- (void)addCollegeTextField {
    MineEditTextField *collegeTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:collegeTextField];
    self.collegeTextField = collegeTextField;
    self.collegeTextField.text = [UserItemTool defaultItem].college;
    
}

///生日

//- (void)addBirthdayLabel {
//    UILabel *birthdayLabel = [[UILabel alloc] init];
//    birthdayLabel.text = @"生日";
//    birthdayLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
//    birthdayLabel.font = LABELFONT;
//    [self.contentScrollView addSubview:birthdayLabel];
//    self.birthdayLabel = birthdayLabel;
//}
//
//- (void)addBirthdayTextField {
//    MineEditTextField *birthdayTextField = [[MineEditTextField alloc] init];
//    [self.contentScrollView addSubview:birthdayTextField];
//    self.birthdayTextField = birthdayTextField;
//    
//    birthdayTextField.delegate = self;
//    
//    // 这里需要添加一个储存生日的本地储存
//    NSString *oldIntroduction = [UserItemTool defaultItem].birthday;
//    if (oldIntroduction==nil || [oldIntroduction isEqualToString:@""]) {
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"填写生日后会匹配出对应的星座哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        birthdayTextField.attributedPlaceholder = string;
//    } else {
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldIntroduction attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
//        birthdayTextField.attributedPlaceholder = string;
//        
//    }
//}

- (void)addQQLabel{
    UILabel *QQLabel = [[UILabel alloc] init];
    QQLabel.text = @"QQ";
    
    QQLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
    
    QQLabel.font = LABELFONT;
    [self.contentScrollView addSubview:QQLabel];
    self.QQLabel = QQLabel;
}

- (void)addQQTextField{
    MineEditTextField *QQTextField = [[MineEditTextField alloc] init];
    NSString *oldQQ = [UserItemTool defaultItem].qq;
    if (![oldQQ isNotBlank]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
        QQTextField.attributedPlaceholder = string;
        
    } else {
        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldQQ attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
        QQTextField.text = oldQQ;
        
    }
    [self.contentScrollView addSubview:QQTextField];
    self.QQTextField = QQTextField;
}

- (void)addPhoneNumberLabel{
    UILabel *phoneNumberLabel = [[UILabel alloc] init];
    phoneNumberLabel.text = @"电话";
    
    phoneNumberLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
    
    phoneNumberLabel.font = LABELFONT;
    [self.contentScrollView addSubview:phoneNumberLabel];
    self.phoneNumberLabel = phoneNumberLabel;
}

- (void)addPhoneNumberTextField{
    MineEditTextField *phoneNumberTextField = [[MineEditTextField alloc] init];
    NSString *oldPhoneNumber = [UserItemTool defaultItem].phone;
    if (![oldPhoneNumber isNotBlank]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
        phoneNumberTextField.attributedPlaceholder = string;
        
    } else {
        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldPhoneNumber attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:0.44] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:0.44]]}];
        phoneNumberTextField.text = oldPhoneNumber;
        
    }
    [self.contentScrollView addSubview:phoneNumberTextField];
    self.phoneNumberTextField = phoneNumberTextField;
}

//- (void)addAcademyLabel{
//    UILabel *academyLabel = [[UILabel alloc] init];
//    academyLabel.text = @"学院";
//    
//    academyLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
//    
//    academyLabel.font = LABELFONT;
//    [self.contentScrollView addSubview:academyLabel];
//    self.academyLabel = academyLabel;
//}
//
//- (void)addMyAcademyLabel{
//    UILabel *myAcademyLabel = [[UILabel alloc] init];
//    myAcademyLabel.text = [UserItemTool defaultItem].college;
//    
//    myAcademyLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#DEDEE2" alpha:1]];
//    
//    myAcademyLabel.font = [UIFont fontWithName:PingFangSCRegular size:16];
//    myAcademyLabel.numberOfLines = 0;
//    [self.contentScrollView addSubview:myAcademyLabel];
//    self.myAcademyLabel = myAcademyLabel;
//}
//
//- (void)addExplainLabel{
//    UILabel *explainLabel = [[UILabel alloc] init];
//    explainLabel.text = @"写下你的联系方式，便于我们与您联系";
//    explainLabel.textColor = [UIColor colorWithRed:188/255.0 green:195/255.0 blue:206/255.0 alpha:0.9];
//    explainLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
//    [self.contentScrollView addSubview:explainLabel];
//    self.explainLabel = explainLabel;
//}
//
//- (void)addSaveButton{
//    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    saveButton.backgroundColor = 
//    [UIColor dm_colorWithLightColor:RGBColor(93, 93, 247, 1) darkColor:RGBColor(85, 77, 250, 1)];
//    
//    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:18];
//    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentScrollView addSubview:saveButton];
//    self.saveButton = saveButton;
//    
//}

#pragma mark - 添加约束
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView);
        make.leading.equalTo(self.headerImageView.mas_trailing);
        make.trailing.equalTo(self.introductionButton.mas_leading);
        make.bottom.equalTo(self.realNameTextField.mas_top);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView).offset(64);
        make.leading.equalTo(self.contentScrollView).offset(32);
        make.height.width.equalTo(self.mas_width).multipliedBy(0.19);
    }];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.width * 0.19 * 0.5;
    
    [self.introductionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView);
        make.trailing.equalTo(self).offset(-59);
        make.height.width.equalTo(@20);
    }];
    
    [self.realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(32);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(34);
    }];
    
    [self.realNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.trailing.equalTo(self).offset(-32);
        make.top.equalTo(self.realNameLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
    [self.stuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.top.equalTo(self.realNameTextField.mas_bottom).offset(20);
    }];
    
    [self.introductionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.trailing.equalTo(self).offset(-32);
        make.top.equalTo(self.stuNumLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.top.mas_equalTo(self.introductionTextField.mas_bottom).offset(20);
    }];
    
    [self.genderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.trailing.equalTo(self).offset(-32);
        make.top.equalTo(self.genderLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
    [self.collegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.top.mas_equalTo(self.genderTextField.mas_bottom).offset(20);
    }];
    
    [self.collegeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.realNameLabel);
        make.trailing.equalTo(self).offset(-32);
        make.top.equalTo(self.collegeLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
//    [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.realNameLabel);
//        make.top.equalTo(self.collegeTextField.mas_bottom).offset(30);
//    }];
//    
//    [self.QQTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.realNameLabel);
//        make.trailing.equalTo(self).offset(-10);
//        make.top.equalTo(self.QQLabel.mas_bottom).offset(3);
//        make.height.equalTo(@45);
//    }];
//    
//    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.realNameLabel);
//        make.top.equalTo(self.QQTextField.mas_bottom).offset(30);
//    }];
//    
//    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.realNameLabel);
//        make.trailing.equalTo(self).offset(-10);
//        make.top.equalTo(self.phoneNumberLabel.mas_bottom).offset(3);
//        make.height.equalTo(@45);
//    }];
//    
//    [self.academyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.realNameLabel);
//        make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(30);
//    }];
//    
//    [self.myAcademyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.academyLabel);
//        make.trailing.equalTo(self).offset(-18);
//        make.leading.greaterThanOrEqualTo(self.academyLabel.mas_trailing).offset(20);
//    }];
//    
//    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.myAcademyLabel.mas_bottom).offset(20);
//        make.trailing.equalTo(self.myAcademyLabel);
//    }];
//    
//    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.explainLabel.mas_bottom).offset(32);
//        make.height.equalTo(@40);
//        make.width.equalTo(@120);
//    }];
//    self.saveButton.layer.cornerRadius = 20;
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.height.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
//    [self.genderPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(self);
//    }];
//    
//    [self.birthdayDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(self);
//    }];
}

#pragma mark - 按钮调用
- (void)saveButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(saveButtonClicked:)]) {
        [self.delegate saveButtonClicked:sender];
    }
}

- (void)backButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked:)]) {
        [self.delegate backButtonClicked:sender];
    }
}

- (void)headerImageTapped:(UIImageView *)sender {
    if ([self.delegate respondsToSelector:@selector(headerImageTapped:)]) {
        [self.delegate headerImageTapped:sender];
    }
}

- (void)showUserInformationIntroduction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(showUserInformationIntroduction:)]) {
        [self.delegate showUserInformationIntroduction:sender];
    }
}

//- (void)textFieldDidChange:(UITextField *)sender {
//    //    NSLog(@"%zd", sender.text.length);
//    if ([sender isEqual:self.realNameTextField]) {
//        self.realNameLabel.text = [NSString stringWithFormat:@"昵称(%zd/10)", sender.text.length];
//    } else if ([sender isEqual:self.introductionTextField]) {
//        self.introductionLabel.text = [NSString stringWithFormat:@"个性签名(%zd/20)", sender.text.length];
//    }
//}

///  从代理里面转过来
- (void)genderTextFieldClicked {
    
    for (int i = 0; i < self.genderAry.count; i++) {
        if ([self.genderTextField.placeholder isEqualToString:self.genderAry[i]]) {
            [self.genderPickerView.pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    self.genderPickerView.hidden = NO;
}

- (void)birthdayTextFieldClicked {
    
    self.birthdayDatePicker.hidden = NO;
}

#pragma mark - UITextFieldDelegate,

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    long len;
//    NSString *tipStr;
//    if ([textField isEqual:self.realNameTextField]) {
//        len = 10;
//        tipStr = @" 昵称长度不能超过10哟～ ";
//    }else if ([textField isEqual:self.introductionTextField]) {
//        len = 20;
//        tipStr = @" 个性签名长度不能超过20哟～ ";
//    }else {
//        return YES;
//    }
//    
//    if (textField.text.length + string.length > len) {
//        [RemindHUD.shared showDefaultHUDWithText:tipStr completion:nil];
//        //截取，当用户粘贴了一个长度大于10的名字时，在交互上体验更好(个人觉得)
//        textField.text = [[textField.text stringByAppendingString:string] substringToIndex:len];
//        return NO;
//    }else {
//        return YES;
//    }
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    if ([textField isEqual:self.genderTextField]) {
//        
//        [self genderTextFieldClicked];
//        return NO;
//    } else if ([textField isEqual:self.collegeTextField]) {
//        
//        [self birthdayTextFieldClicked];
//        return NO;
//    }
//        
//    return YES;
//}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
//    NSLog(@"%zd", row);
    self.genderTextField.text = self.genderAry[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.genderAry[row];
}

#pragma mark - pmppickerview

- (void)sureButtonClicked:(id)sender {
//    NSLog(@"picker view");
    // 上传数据保存到本地
    self.genderPickerView.hidden = YES;
}

#pragma mark - pmpdatepicker

- (void)datePickerSureButtonClicked:(id)sender {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * str = [dateFormatter stringFromDate:self.birthdayDatePicker.datePicker.date];
    self.collegeTextField.text = str;
    // 上传数据并保存到本地
    self.birthdayDatePicker.hidden = YES;
}

#pragma mark - lazy

- (PMPPickerView *)genderPickerView  {
    if (_genderPickerView == nil) {
        _genderPickerView = [[PMPPickerView alloc] init];
        _genderPickerView.pickerView.dataSource = self;
        _genderPickerView.pickerView.delegate = self;
        _genderPickerView.delegate = self;
    }
    return _genderPickerView;
}

- (NSArray *)genderAry {
    if (_genderAry == nil) {
        _genderAry = @[
            @"男",
            @"女",
            @"X星人",
        ];
    }
    return _genderAry;
}

- (PMPDatePicker *)birthdayDatePicker {
    if (_birthdayDatePicker == nil) {
        _birthdayDatePicker = [[PMPDatePicker alloc] init];
        _birthdayDatePicker.delegate = self;
        _birthdayDatePicker.datePicker.maximumDate = [NSDate date];
        _birthdayDatePicker.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CHT"];
        _birthdayDatePicker.datePicker.timeZone = NSTimeZone.localTimeZone;
        _birthdayDatePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        if (@available(iOS 13.4, *)) {
            _birthdayDatePicker.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
    return _birthdayDatePicker;
}


@end
