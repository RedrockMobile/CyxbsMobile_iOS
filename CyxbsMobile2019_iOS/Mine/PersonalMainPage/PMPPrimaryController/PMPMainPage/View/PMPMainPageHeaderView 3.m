//
//  PMPMainPageHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPMainPageHeaderView.h"

@interface PMPMainPageHeaderView ()

/**
 大约占 2/5 和3/5
 */

/// 透明层
@property (nonatomic, strong) UIView * transparentMaskView;
/// 半透明层
@property (nonatomic, strong) UIView * translucentMaskView;

/// 昵称下面的按钮
@property (nonatomic, strong) NSArray <PMPTextButton *> * textButtonAry;
/// 文字信息
@property (nonatomic, strong) NSArray * textButtonTitlesAry;

/// 头像
@property (nonatomic, strong) PMPAvatarImgButton * avatarImgButton;
/// 昵称
@property (nonatomic, strong) UILabel * nicknameLabel;
/// 编辑信息
@property (nonatomic, strong) PMPEditingButton * editingButton;
/// ID文字
@property (nonatomic, strong) UILabel * IDLabel;

@end

@implementation PMPMainPageHeaderView

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
    // self.transparentMaskView and self.translucentMaskView
    [self addSubview:self.transparentMaskView];
    
    [self addSubview:self.translucentMaskView];
    // 设置圆角, topLeft | topRight
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.translucentMaskView.bounds
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft
                                                         cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.translucentMaskView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.translucentMaskView.layer.mask = maskLayer;
    
    //  textButtonAry
    NSMutableArray * tempMAry = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.textButtonTitlesAry.count; i++) {
        [tempMAry addObject:[self createTextButtonWithIndex:i]];
    }
    self.textButtonAry = [tempMAry copy];
    
    // avatarImgButton
    [self addSubview:self.avatarImgButton];
    self.avatarImgButton.jh_size = CGSizeMake(88, 88);
    
    //  nicknameLabel
    [self addSubview:self.nicknameLabel];
    
    // editingButton
    [self addSubview:self.editingButton];
}

#pragma mark - event response

- (void)textButtonClicked:(PMPTextButton *)sender {
    if ([self.delegate respondsToSelector:@selector(textButtonClickedWithIndex:)]) {
        [self.delegate textButtonClickedWithIndex:sender.index];
    }
}

- (void)avatarImgViewCliced:(PMPTextButton *)sender {
    if ([self.delegate respondsToSelector:@selector(avatarImgViewCliced:)]) {
        [self.delegate avatarImgButtonClicked];
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

#pragma mark - lazy

- (UIView *)transparentMaskView {
    if (_transparentMaskView == nil) {
        _transparentMaskView = [[UIView alloc] init];
        _transparentMaskView.backgroundColor = [UIColor clearColor];
    }
    return _transparentMaskView;
}

- (UIView *)translucentMaskView {
    if (_translucentMaskView == nil) {
        _translucentMaskView = [[UIView alloc] init];
        _translucentMaskView.backgroundColor = [UIColor colorNamed:@"white_0.95&black"];
    }
    return _translucentMaskView;
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

- (PMPAvatarImgButton *)avatarImgButton {
    if (_avatarImgButton == nil) {
        _avatarImgButton = [[PMPAvatarImgButton alloc] init];
        [_avatarImgButton addTarget:self action:@selector(avatarImgViewCliced:)];
    }
    return _avatarImgButton;
}

- (UILabel *)nicknameLabel {
    if (_nicknameLabel == nil) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont fontWithName:PingFangSCBold size:22];
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_nicknameLabel sizeToFit];
    }
    return _nicknameLabel;
}

- (PMPEditingButton *)editingButton {
    if (_editingButton == nil) {
        _editingButton = [[PMPEditingButton alloc] init];
    }
    return _editingButton;
}

- (UILabel *)IDLabel {
    if (_IDLabel == nil) {
        _IDLabel = [[UILabel alloc] init];
        [_IDLabel sizeToFit];
        _IDLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _IDLabel.textColor = [UIColor colorNamed:@"21_49_91_0.8&"];
    }
    return _IDLabel;
}

@end
