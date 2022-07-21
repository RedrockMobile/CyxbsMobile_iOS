//
//  BaseTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "BaseTableViewCell.h"
#import <Masonry/Masonry.h>

@implementation BaseTableViewCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}
#pragma mark - configure
- (void)configure {
    //profile picture
    [self.contentView addSubview:self.avatarImgView];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(25);
        make.left.equalTo(self).mas_offset(16);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(42);
    }];
    //name
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_equalTo(25);
        make.left.equalTo(self.avatarImgView.mas_right).mas_offset(13);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(22);
    }];
    //bio
    [self.contentView addSubview:self.bioLabel];
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(48);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(17);
    }];
    //follow button
    [self.contentView addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(31);
        make.right.equalTo(self.mas_rightMargin).mas_offset(-17);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
}

#pragma mark - clicked

- (void)followBtnClicked:(UIButton *)followBtn {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:Clicked:)]) {
        [self.delegate tableViewCell:self Clicked:followBtn];
    }
}

#pragma mark - getter

- (UIImageView *)avatarImgView {
    if (_avatarImgView == nil) {
        _avatarImgView = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        _avatarImgView.clipsToBounds = true;
        _avatarImgView.layer.cornerRadius = 21;
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
        _nameLabel.textColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(240, 240, 242, 1)];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)bioLabel {
    if (_bioLabel == nil) {
        _bioLabel= [[UILabel alloc] initWithFrame:(CGRectZero)];
        _bioLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _bioLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.4) darkColor:RGBColor(240, 240, 242, 0.4)];
    }
    return _bioLabel;
}

- (UIButton *)followBtn {
    if (_followBtn == nil) {
        _followBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_followBtn addTarget:self
                       action:@selector(followBtnClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        _followBtn.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:13];
        [_followBtn setTitle:@"+关注"
                    forState:UIControlStateNormal];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle_27_normal"]
                              forState:UIControlStateNormal];
#warning "找不到 ‘white_1&white_1’ 对应的颜色"
        [_followBtn setTitleColor:[UIColor colorNamed:@"white_1&white_1"]
                         forState:UIControlStateNormal];
        
        [_followBtn setTitle:@"互相关注"
                    forState:UIControlStateSelected];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle_27_selected"]
                              forState:UIControlStateSelected];
        [_followBtn setTitleColor:[UIColor dm_colorWithLightColor:RGBColor(148, 166, 196, 1) darkColor:RGBColor(0, 0, 0, 1)]
                         forState:UIControlStateSelected];
        [_followBtn sizeToFit];
    }
    return _followBtn;
}

#pragma mark - private

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
