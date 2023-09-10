//
//  CenterPromptBoxView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterPromptBoxView.h"


@implementation CenterPromptBoxView

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.backgroundImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.daysLab];
        [self addSubview:self.daysNumLab];
        [self addSubview:self.avatarImgView];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

- (void)setPosition {
    // avatarImgView
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(17);
        make.left.equalTo(self).offset(31);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    // nameLab
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18);
        make.left.equalTo(self.avatarImgView.mas_right).offset(13);
        make.right.equalTo(self);
        make.height.mas_equalTo(19);
    }];
    // daysLab
    [self.daysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(2);
        make.left.right.height.equalTo(self.nameLab);
    }];
    // daysNumLab
    [self.daysNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(39);
        make.bottom.equalTo(self).offset(-20);
        make.left.equalTo(self.daysLab).offset(123);
        make.size.mas_equalTo(CGSizeMake(38, 19));
    }];
}



#pragma mark - Getter

- (UIImageView *)backgroundImgView {
    if (_backgroundImgView == nil) {
        _backgroundImgView = [[UIImageView alloc] init];
        _backgroundImgView.image = [UIImage imageNamed:@"center_promptBox_backgroundImg"];
        _backgroundImgView.clipsToBounds = YES;
        [_backgroundImgView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _backgroundImgView;
}

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.text = @"Hi，";
        _nameLab.font = [UIFont fontWithName:PingFangSC size:14];
        _nameLab.textColor = UIColor.blackColor;
        _nameLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:1.0];
    }
    return _nameLab;
}

- (UILabel *)daysLab {
    if (_daysLab == nil) {
        _daysLab = [[UILabel alloc] init];
        _daysLab.textAlignment = NSTextAlignmentLeft;
        _daysLab.text = @"这是你来到游乐场的第    天";
        _daysLab.font = [UIFont fontWithName:PingFangSC size:12];
        _daysLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.5];
    }
    return _daysLab;
}

- (UILabel *)daysNumLab {
    if (_daysNumLab == nil) {
        _daysNumLab = [[UILabel alloc] init];
        _daysNumLab.textAlignment = NSTextAlignmentLeft;
        _daysNumLab.text = @" ";
        _daysNumLab.font = [UIFont fontWithName:PingFangSCBold size:16];
        _daysNumLab.textColor = [UIColor colorWithHexString:@"#4A44E4" alpha:1.0];
    }
    return _daysNumLab;
}

- (UIImageView *)avatarImgView {
    if (_avatarImgView == nil) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.image = [UIImage imageNamed:@"defaultStudentImage"];
        _avatarImgView.layer.cornerRadius = 21.5;
    }
    return _avatarImgView;
}

@end
