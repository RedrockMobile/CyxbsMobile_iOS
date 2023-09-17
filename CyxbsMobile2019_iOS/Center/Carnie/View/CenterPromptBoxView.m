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
        self.backgroundColor = UIColor.whiteColor;
//        [self addSubview:self.backgroundImgView];
        [self addSubview:self.nameLab];
        [self addSubview:self.daysLab];
        [self addSubview:self.avatarImgView];
        [self setPosition];
        [self setNum:0];
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
        make.left.height.equalTo(self.nameLab);
    }];
}

-(void)setNum:(NSInteger)num {
    NSString *dayNumsString = [NSString stringWithFormat:@"%ld", num];
    NSString *prefixString = @"这是你来到属于你的邮乐园的第 ";
    NSString *suffixString = @" 天";
    
    // 创建前缀部分的富文本
    NSAttributedString *prefixAttributedString = [[NSAttributedString alloc] initWithString:prefixString attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#15315B" alpha:0.5],
        NSFontAttributeName: [UIFont fontWithName:PingFangSC size:12]
    }];
    
    // 创建数字部分的富文本
    NSAttributedString *dayNumsAttributedString = [[NSAttributedString alloc] initWithString:dayNumsString attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#4A44E4" alpha:1.0],
        NSFontAttributeName: [UIFont systemFontOfSize:16]
    }];
    
    // 创建后缀部分的富文本
    NSAttributedString *suffixAttributedString = [[NSAttributedString alloc] initWithString:suffixString attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#15315B" alpha:0.5],
        NSFontAttributeName: [UIFont fontWithName:PingFangSC size:12]
    }];
    
    // 拼接三个富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:prefixAttributedString];
    [attributedString appendAttributedString:dayNumsAttributedString];
    [attributedString appendAttributedString:suffixAttributedString];
    self.daysLab.attributedText = attributedString;
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
        _daysLab.font = [UIFont fontWithName:PingFangSC size:12];
        _daysLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.5];
    }
    return _daysLab;
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
