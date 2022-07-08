//
//  PMPHomePageHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPHomePageHeaderView.h"

@interface PMPHomePageHeaderView ()

/// 昵称下面的按钮
@property (nonatomic, strong) NSArray <PMPTextButton *> * textButtonAry;
/// 文字信息
@property (nonatomic, strong) NSArray <NSString *> * textButtonTitlesAry;

/// 认证的身份,0~3张
@property (nonatomic, strong) NSArray <UIImageView *> * imgViewAry;

/// 头像
@property (nonatomic, strong) PMPAvatarImgView * avatarImgButton;
/// 昵称
@property (nonatomic, strong) UILabel * nicknameLabel;
/// 编辑信息
@property (nonatomic, strong) PMPEditingButton * editingButton;
/// ID文字
@property (nonatomic, strong) UILabel * IDLabel;

/// 个性签名
@property (nonatomic, strong) UILabel * PersonalSignatureLabel;
/// 信息
@property (nonatomic, strong) UILabel * infoLabel;

/// 关注按钮
@property (nonatomic, strong) UIButton * followButton;

/// 透明层
@property (nonatomic, strong) PMPBasicActionView * transparentView;
/// 白色的View
@property (nonatomic, strong) UIView * whiteView;

@end

@implementation PMPHomePageHeaderView

- (void)refreshDataWithNickname:(NSString *)nickname
                          grade:(NSString *)grade
                  constellation:(NSString *)constellation
                         gender:(NSString *)gender
                   introduction:(NSString *)introduction
                            uid:(NSInteger)uid
                      photo_src:(nonnull NSString *)photo_src
                         isSelf:(BOOL)isSelf
                    identityies:(NSArray <NSString *> *)identityies
                        isFocus:(BOOL)isFocus{
    self.nicknameLabel.text = nickname;
    self.IDLabel.text = [@"ID: " stringByAppendingFormat:@"%ld", uid];
    self.infoLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", grade, constellation, gender];
    self.PersonalSignatureLabel.text = introduction;
    [self.avatarImgButton.avatarImgView sd_setImageWithURL:[NSURL URLWithString:photo_src]];
    self.followButton.hidden = isSelf;
    if (isSelf == false) {
        self.followButton.selected = isFocus;
    }
    self.editingButton.hidden = !isSelf;
    if (identityies && identityies.count > 0) {
        [identityies enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.imgViewAry[idx] sd_setImageWithURL:[NSURL URLWithString:obj]];
        }];
    }
}

- (void)refreshDataWithFans:(NSInteger)fans
                    follows:(NSInteger)follows
                     praise:(NSInteger)praise {
    self.textButtonAry[0].titleLabel.text = [NSString stringWithFormat:@"%zd", fans];
    self.textButtonAry[1].titleLabel.text = [NSString stringWithFormat:@"%zd", follows];
    self.textButtonAry[2].titleLabel.text = [NSString stringWithFormat:@"%zd", praise];
}

- (void)changeFollowStateSelected:(BOOL)selected {
    self.followButton.selected = selected;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    
    // self.transparentView
    [self addSubview:self.transparentView];
    [self.transparentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    // self.whiteView
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.64477);
    }];
    
    // avatarImgButton
    [self addSubview:self.avatarImgButton];
    CGFloat width1 = (SCREEN_WIDTH / 375) * 97;
    CGFloat height1 = width1;
    self.avatarImgButton.cornerRadius = width1/2;
    [self.avatarImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.whiteView.mas_top);
        make.left.mas_equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(width1, height1));
    }];
    
    // _IDLabel
    [self addSubview:self.IDLabel];
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgButton);
        make.top.mas_equalTo(self.avatarImgButton.mas_bottom).offset(10);
    }];
    
    // editingButton
    [self addSubview:self.editingButton];
    CGFloat width2 = self.editingButton.textLabel.jh_width + self.editingButton.iconImgView.jh_width + 10;
    CGFloat height2 = self.editingButton.iconImgView.jh_height + 20;
    [self.editingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        make.left.mas_equalTo(self.IDLabel.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(width2, height2));
    }];
    
    // followButton
    [self addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 30));
        make.centerY.mas_equalTo(self.IDLabel.mas_bottom);
        make.right.mas_equalTo(self).offset(-16);
    }];
    self.followButton.hidden = YES;
    
    //  textButtonAry
    NSMutableArray * tempMAry = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.textButtonTitlesAry.count; i++) {
        [tempMAry addObject:[self createTextButtonWithIndex:i]];
    }
    self.textButtonAry = [tempMAry copy];
    CGFloat textButtonWidth = (SCREEN_WIDTH - 97 - 16) / 3;
    UIView * leftView = self.avatarImgButton;
    for (int i = 0; i < self.textButtonAry.count; i++) {
        PMPTextButton * button = self.textButtonAry[i];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right);
            make.top.mas_equalTo(self.whiteView);
            make.bottom.mas_equalTo(leftView);
            make.width.mas_equalTo(textButtonWidth);
        }];
        leftView = button;
    }
    
    //  nicknameLabel
    PMPTextButton * tempButton = self.textButtonAry[0];
    [self addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.whiteView.mas_top).offset(-4);
        make.right.mas_equalTo(self).offset(-14);
        make.left.mas_equalTo(tempButton.subtitleLabel.mas_left);
    }];
    
    //
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.IDLabel);
        make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(20);
    }];
    
    //
    [self addSubview:self.PersonalSignatureLabel];
    [self.PersonalSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLabel);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(4);
    }];
    
    self.imgViewAry = @[
        [self createImageView],
        [self createImageView],
        [self createImageView]
    ];
    
    leftView = self;
    for (int i = 0; i < self.imgViewAry.count; i++) {
        UIImageView * imageView = self.imgViewAry[i];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            MASViewAttribute * attribute = [leftView isEqual:self] ? leftView.mas_left : leftView.mas_right;
            CGFloat offset = [leftView isEqual:self] ? 16 : 6;
            make.left.mas_equalTo(attribute).offset(offset);
            make.top.mas_equalTo(self.PersonalSignatureLabel.mas_bottom).offset(6);
            make.height.mas_lessThanOrEqualTo(30);
            make.width.mas_lessThanOrEqualTo(self.mas_width).dividedBy(3);
            if ([imageView isEqual:[self.imgViewAry lastObject]]) {
                make.right.mas_equalTo(self).offset(-16);
            }
        }];
        leftView = imageView;
    }
}

#pragma mark - event response

- (void)textButtonClicked:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(textButtonClickedWithIndex:)]) {
        [self.delegate textButtonClickedWithIndex:((PMPTextButton *)sender.view).index];
    }
}

- (void)editingButtonClicked {
    if ([self.delegate respondsToSelector:@selector(editingButtonClicked)]) {
        [self.delegate editingButtonClicked];
    }
}

- (void)backgroundViewClicked {
    if ([self.delegate respondsToSelector:@selector(backgroundViewClicked)]) {
        [self.delegate backgroundViewClicked];
    }
}

- (void)followButtonClicked {
    if ([self.delegate respondsToSelector:@selector(followButtonClicked:)]) {
        [self.delegate followButtonClicked:self.followButton];
    }
}

#pragma mark - private

- (PMPTextButton *)createTextButtonWithIndex:(NSUInteger)index {
    PMPTextButton * button = [[PMPTextButton alloc] init];
    [button setTitle:@"0"
            subtitle:self.textButtonTitlesAry[index]
               index:index];
    [button addTarget:self action:@selector(textButtonClicked:)];
    return button;
}

- (UIImageView *)createImageView {
    UIImageView * imageView = [[UIImageView alloc] init];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sizeToFit];
    
    return imageView;
}

#pragma mark - lazy

- (PMPBasicActionView *)transparentView {
    if (_transparentView == nil) {
        _transparentView = [[PMPBasicActionView alloc] init];
        _transparentView.backgroundColor = [UIColor clearColor];
        [_transparentView addTarget:self action:@selector(backgroundViewClicked)];
    }
    return _transparentView;
}

- (UIView *)whiteView {
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor =
        [UIColor dm_colorWithLightColor:RGBColor(255, 255, 255, 0.95) darkColor:UIColor.blackColor];
        _whiteView.layer.cornerRadius = 8;
    }
    return _whiteView;
}

- (NSArray *)textButtonTitlesAry {
    if (_textButtonTitlesAry == nil) {
        _textButtonTitlesAry = @[
            @"粉丝",
            @"关注",
            @"获赞",
        ];
    }
    return _textButtonTitlesAry;
}

- (PMPAvatarImgView *)avatarImgButton {
    if (_avatarImgButton == nil) {
        _avatarImgButton = [[PMPAvatarImgView alloc] init];
    }
    return _avatarImgButton;
}

- (UILabel *)nicknameLabel {
    if (_nicknameLabel == nil) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont fontWithName:PingFangSCBold size:22];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_nicknameLabel sizeToFit];
    }
    return _nicknameLabel;
}

- (PMPEditingButton *)editingButton {
    if (_editingButton == nil) {
        _editingButton = [[PMPEditingButton alloc] init];
        [_editingButton addTarget:self action:@selector(editingButtonClicked)];
    }
    return _editingButton;
}

- (UILabel *)IDLabel {
    if (_IDLabel == nil) {
        _IDLabel = [[UILabel alloc] init];
        [_IDLabel sizeToFit];
        _IDLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _IDLabel.textColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.8) darkColor:RGBColor(240, 240, 242, 0.8)];
    }
    return _IDLabel;
}

- (UILabel *)PersonalSignatureLabel {
    if (_PersonalSignatureLabel == nil) {
        _PersonalSignatureLabel = [[UILabel alloc] init];
        [_PersonalSignatureLabel sizeToFit];
        _PersonalSignatureLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        _PersonalSignatureLabel.textColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.7) darkColor:RGBColor(240, 240, 242, 0.7)];
    }
    return _PersonalSignatureLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel sizeToFit];
        _infoLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _infoLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.8) darkColor:RGBColor(240, 240, 242, 0.8)];
    }
    return _infoLabel;
}

- (UIButton *)followButton {
    if (_followButton == nil) {
        _followButton = [[UIButton alloc] init];
        _followButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
        // normal
        [_followButton setImage:[UIImage imageNamed:@"homepage_focused_false"]
                       forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"homepage_focused_true"]
                       forState:UIControlStateSelected];
        [_followButton addTarget:self action:@selector(followButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _followButton;
}
@end

