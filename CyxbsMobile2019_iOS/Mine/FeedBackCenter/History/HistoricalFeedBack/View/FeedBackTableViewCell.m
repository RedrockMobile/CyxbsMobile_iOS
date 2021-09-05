//
//  FeedBackTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackTableViewCell.h"

@implementation FeedBackTableViewCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.rightImgView];
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.redSpotView];
    
    // config self
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupFrame {
    // configure rightImgView
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // configure titleLabel
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    // configure subtitleLabel
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(4);
    }];
    
    //config separateLine
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    // configure redSpotView
    [self.redSpotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.rightImgView);
        make.height.width.mas_equalTo(4);
    }];
}

#pragma mark - setter

- (void)setCellModel:(FeedBackModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.subtitleLabel.text = getTimeStrWithDateFormat(cellModel.CreatedAt, @"yyyy-MM-dd'T'HH:mm:ss'+08:00'", @"yyyy/HH/dd HH:mm");
    self.rightImgView.image = [UIImage imageNamed:cellModel.replied ? @"标签-已回复" : @"标签-未回复"];
    
    if (cellModel.replied == NO) {
        self.redSpotView.hidden = YES;
    } else {
        self.redSpotView.hidden = [[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"feedback_history_%zd", cellModel.ID]] boolValue];
    }
    
    [self setupFrame];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        _titleLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _subtitleLabel.font = [UIFont fontWithName:PingFangSCMedium size:13];
        _subtitleLabel.textColor = [UIColor colorNamed:@"41_65_105_1&223_223_227_1"];
    }
    return _subtitleLabel;
}

- (UIImageView *)rightImgView {
    if (_rightImgView == nil) {
        _rightImgView = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        [_rightImgView sizeToFit];
    }
    return _rightImgView;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _separateLine.backgroundColor = [UIColor colorNamed:@"221_230_244_1&43_44_45_1"];
    }
    return _separateLine;
}

- (UIView *)redSpotView {
    if (_redSpotView == nil) {
        _redSpotView = [[UIView alloc] init];
        _redSpotView.backgroundColor = [UIColor redColor];
        _redSpotView.layer.cornerRadius = 2;
    }
    return _redSpotView;
}

@end
