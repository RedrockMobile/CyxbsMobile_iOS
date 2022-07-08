//
//  EditMyInfoContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Modified by Edioth on 2021/10/12
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoContentView.h"

#define LABELCOLOR [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]
#define PLACEHOLDERCOLOR [UIColor colorNamed:@"Mine_EditInfo_PlaceholderColor"]

#define LABELFONT [UIFont fontWithName:@"PingFangSC-Semibold" size:15]
#define PLACEHOLDERFONT [UIFont fontWithName:@"PingFangSC-Regular" size:15]

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
@property (nonatomic, weak) UILabel *nicknameLabel;
@property (nonatomic, weak) UILabel *introductionLabel;
@property (nonatomic, weak) UILabel * genderLabel;
@property (nonatomic, weak) UILabel * birthdayLabel;
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
    [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:RGBColor(38, 38, 38, 1)];
    self.contentScrollView.layer.cornerRadius = 16;
    self.contentScrollView = scrollView;
    self.contentScrollView.transform = CGAffineTransformMakeScale(0.9, 0.95);
    
    [self addGestureView];
    [self addHeaderImageView];
    [self addIntroductionButton];
    [self addNicknameLabel];
    [self addNicknameTextField];
    [self addIntroductionLabel];
    [self addIntroductionTextField];
    [self addGenderLabel];
    [self addGenderTextField];
    [self addBirthdayLabel ];
    [self addBirthdayTextField];
    [self addQQLabel];
    [self addQQTextField];
    [self addPhoneNumberLabel];
    [self addPhoneNumberTextField];
    [self addAcademyLabel];
    [self addMyAcademyLabel];
    [self addExplainLabel];
    [self addSaveButton];
    //----
    [self addSubview:self.genderPickerView];
    self.genderPickerView.hidden = YES;
    
    [self addSubview:self.birthdayDatePicker];
    self.birthdayDatePicker.hidden = YES;
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

- (void)addNicknameLabel{
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.text = @"昵称(0/10)";
    
    nicknameLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    
    nicknameLabel.font = LABELFONT;
    [self.contentScrollView addSubview:nicknameLabel];
    self.nicknameLabel = nicknameLabel;
}

- (void)addNicknameTextField{
    MineEditTextField *nicknameTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:nicknameTextField];
    self.nicknameTextField = nicknameTextField;
    
    nicknameTextField.delegate = self;
    
    NSString *oldNickname = [UserItemTool defaultItem].nickname;
    if (oldNickname==nil || [oldNickname isEqualToString:@""]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        nicknameTextField.attributedPlaceholder = string;
        
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldNickname attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        nicknameTextField.attributedPlaceholder = string;
        
    }
    [self.nicknameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
}

- (void)addIntroductionLabel{
    UILabel *introductionLabel = [[UILabel alloc] init];
    introductionLabel.text = @"个性签名(0/20)";
    introductionLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    introductionLabel.font = LABELFONT;
    [self.contentScrollView addSubview:introductionLabel];
    self.introductionLabel = introductionLabel;
}

- (void)addIntroductionTextField{
    MineEditTextField *introductionField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:introductionField];
    self.introductionTextField = introductionField;
    
    introductionField.delegate = self;
    
    NSString *oldIntroduction = [UserItemTool defaultItem].introduction;
    if (oldIntroduction==nil || [oldIntroduction isEqualToString:@""]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        introductionField.attributedPlaceholder = string;
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldIntroduction attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        introductionField.attributedPlaceholder = string;
        
    }
    [self.introductionTextField addTarget:self
                                   action:@selector(textFieldDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
}

/// 性别和生日

- (void)addGenderLabel {
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.text = @"性别";
    genderLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    genderLabel.font = LABELFONT;
    [self.contentScrollView addSubview:genderLabel];
    self.genderLabel = genderLabel;
}

- (void)addGenderTextField {
    MineEditTextField *genderTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:genderTextField];
    self.genderTextField = genderTextField;
    
    genderTextField.delegate = self;
    
    NSString *oldGender = [UserItemTool defaultItem].gender;
    if (oldGender==nil || [oldGender isEqualToString:@""]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请选择性别" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        genderTextField.attributedPlaceholder = string;
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldGender attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        genderTextField.attributedPlaceholder = string;
        
    }
}

- (void)addBirthdayLabel {
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.text = @"生日";
    birthdayLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    birthdayLabel.font = LABELFONT;
    [self.contentScrollView addSubview:birthdayLabel];
    self.birthdayLabel = birthdayLabel;
}

- (void)addBirthdayTextField {
    MineEditTextField *birthdayTextField = [[MineEditTextField alloc] init];
    [self.contentScrollView addSubview:birthdayTextField];
    self.birthdayTextField = birthdayTextField;
    
    birthdayTextField.delegate = self;
    
    // 这里需要添加一个储存生日的本地储存
    NSString *oldIntroduction = [UserItemTool defaultItem].birthday;
    if (oldIntroduction==nil || [oldIntroduction isEqualToString:@""]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"填写生日后会匹配出对应的星座哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        birthdayTextField.attributedPlaceholder = string;
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldIntroduction attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        birthdayTextField.attributedPlaceholder = string;
        
    }
}

- (void)addQQLabel{
    UILabel *QQLabel = [[UILabel alloc] init];
    QQLabel.text = @"QQ";
    
    QQLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    
    QQLabel.font = LABELFONT;
    [self.contentScrollView addSubview:QQLabel];
    self.QQLabel = QQLabel;
}

- (void)addQQTextField{
    MineEditTextField *QQTextField = [[MineEditTextField alloc] init];
    NSString *oldQQ = [UserItemTool defaultItem].qq;
    if (oldQQ==nil || [oldQQ isEqualToString:@""]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        QQTextField.attributedPlaceholder = string;
        
        
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldQQ attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        QQTextField.attributedPlaceholder = string;
        
    }
    [self.contentScrollView addSubview:QQTextField];
    self.QQTextField = QQTextField;
}

- (void)addPhoneNumberLabel{
    UILabel *phoneNumberLabel = [[UILabel alloc] init];
    phoneNumberLabel.text = @"电话";
    
    phoneNumberLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    
    phoneNumberLabel.font = LABELFONT;
    [self.contentScrollView addSubview:phoneNumberLabel];
    self.phoneNumberLabel = phoneNumberLabel;
}

- (void)addPhoneNumberTextField{
    MineEditTextField *phoneNumberTextField = [[MineEditTextField alloc] init];
    NSString *oldPhoneNumber = [UserItemTool defaultItem].phone;
    if (oldPhoneNumber==nil || [oldPhoneNumber isEqualToString:@""]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"完善你的个人信息哦" attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        phoneNumberTextField.attributedPlaceholder = string;
        
    } else {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:oldPhoneNumber attributes:@{NSFontAttributeName: PLACEHOLDERFONT, NSForegroundColorAttributeName: PLACEHOLDERCOLOR}];
        phoneNumberTextField.attributedPlaceholder = string;
        
    }
    [self.contentScrollView addSubview:phoneNumberTextField];
    self.phoneNumberTextField = phoneNumberTextField;
}

- (void)addAcademyLabel{
    UILabel *academyLabel = [[UILabel alloc] init];
    academyLabel.text = @"学院";
    
    academyLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    
    academyLabel.font = LABELFONT;
    [self.contentScrollView addSubview:academyLabel];
    self.academyLabel = academyLabel;
}

- (void)addMyAcademyLabel{
    UILabel *myAcademyLabel = [[UILabel alloc] init];
    myAcademyLabel.text = [UserItemTool defaultItem].college;
    
    myAcademyLabel.textColor = [UIColor colorNamed:@"Mine_Store_LabelColor"];
    
    myAcademyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    myAcademyLabel.numberOfLines = 0;
    [self.contentScrollView addSubview:myAcademyLabel];
    self.myAcademyLabel = myAcademyLabel;
}

- (void)addExplainLabel{
    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.text = @"写下你的联系方式，便于我们与您联系";
    explainLabel.textColor = [UIColor colorWithRed:188/255.0 green:195/255.0 blue:206/255.0 alpha:0.9];
    explainLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.contentScrollView addSubview:explainLabel];
    self.explainLabel = explainLabel;
}

- (void)addSaveButton{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    saveButton.backgroundColor = 
    [UIColor dm_colorWithLightColor:RGBColor(93, 93, 247, 1) darkColor:RGBColor(85, 77, 250, 1)];
    
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:saveButton];
    self.saveButton = saveButton;
    
}

#pragma mark - 添加约束
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView);
        make.leading.equalTo(self.headerImageView.mas_trailing);
        make.trailing.equalTo(self.introductionButton.mas_leading);
        make.bottom.equalTo(self.nicknameTextField.mas_top);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentScrollView).offset(16);
        make.height.width.equalTo(self.mas_width).multipliedBy(0.19);
    }];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.width * 0.19 * 0.5;
    
    [self.introductionButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.mas_equalTo(self.introductionTextField.mas_bottom).offset(30);
    }];
    
    [self.genderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.genderLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.mas_equalTo(self.genderTextField.mas_bottom).offset(30);
    }];
    
    [self.birthdayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(3);
        make.height.equalTo(@45);
    }];
    
    [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel);
        make.top.equalTo(self.birthdayTextField.mas_bottom).offset(30);
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
    
    [self.myAcademyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.academyLabel);
        make.trailing.equalTo(self).offset(-18);
        make.leading.greaterThanOrEqualTo(self.academyLabel.mas_trailing).offset(20);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myAcademyLabel.mas_bottom).offset(20);
        make.trailing.equalTo(self.myAcademyLabel);
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
    
    [self.genderPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    [self.birthdayDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
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

- (void)textFieldDidChange:(UITextField *)sender {
    //    NSLog(@"%zd", sender.text.length);
    if ([sender isEqual:self.nicknameTextField]) {
        self.nicknameLabel.text = [NSString stringWithFormat:@"昵称(%zd/10)", sender.text.length];
    } else if ([sender isEqual:self.introductionLabel]) {
        self.introductionLabel.text = [NSString stringWithFormat:@"个性签名(%zd/20)", sender.text.length];
    }
}

///  从代理里面转过来
- (void)genderTextFieldClicked {
    
    for (int i = 0; i < self.genderAry.count; i++) {
        if ([self.genderTextField.placeholder isEqualToString:self.genderAry[i]]) {
            [self.genderPickerView.pickerView selectedRowInComponent:i];
            break;
        }
    }
    self.genderPickerView.hidden = NO;
}

- (void)birthdayTextFieldClicked {
    
    self.birthdayDatePicker.hidden = NO;
}

#pragma mark - UITextFieldDelegate,

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    long len;
    NSString *tipStr;
    if ([textField isEqual:self.nicknameTextField]) {
        len = 10;
        tipStr = @" 昵称长度不能超过10哟～ ";
    }else if ([textField isEqual:self.introductionTextField]) {
        len = 20;
        tipStr = @" 个性签名长度不能超过20哟～ ";
    }else {
        return YES;
    }
    
    if (textField.text.length + string.length > len) {
        [NewQAHud showHudWith:tipStr AddView:self];
        //截取，当用户粘贴了一个长度大于10的名字时，在交互上体验更好(个人觉得)
        textField.text = [[textField.text stringByAppendingString:string] substringToIndex:len];
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.genderTextField]) {
        
        [self genderTextFieldClicked];
        return NO;
    } else if ([textField isEqual:self.birthdayTextField]) {
        
        [self birthdayTextFieldClicked];
        return NO;
    }
        
    return YES;
}

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
    self.birthdayTextField.text = str;
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
