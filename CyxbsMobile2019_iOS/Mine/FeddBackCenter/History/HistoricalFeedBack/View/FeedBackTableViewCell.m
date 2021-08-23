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
        [self setupFrame];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.rightImgView];
    [self.contentView addSubview:self.separateLine];
}

- (void)setupFrame {
    
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

#pragma mark - private

- (NSString *)getTimeFromTimestamp:(long)time {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    //将时间转换为字符串
    NSString * timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
