//
//  ActivityTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self BuildUI];
        [self BuildFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)BuildUI {
    ///背景
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:239/255.0 green:245/255.0 blue:253/255.0 alpha:1.0];
    backView.layer.cornerRadius = 8;
    [self addSubview:backView];
    _backView = backView;
    
    ///活动名称
    VolunteerLabel *activityLabel = [[VolunteerLabel alloc] init];
    activityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    activityLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    activityLabel.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:activityLabel];
    _activityLabel = activityLabel;
    
    ///时长
    UILabel *hourLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTextColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]];
    [_backView addSubview:hourLabel];
    _hourLabel = hourLabel;
    
    ///日期
    UILabel *dateLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTextColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]];
    [_backView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    ///倒计时
    UILabel *countdownLabel = [[UILabel alloc] init];
    countdownLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    countdownLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:countdownLabel];
    _countdownLabel = countdownLabel;
    
}

- (void) BuildFrame {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0347);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0507);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0507);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.1491);
    }];
    
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0197);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.0373);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.3013);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0692);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0542);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0643);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0813);
        make.left.right.height.mas_equalTo(_hourLabel);
    }];
    
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0209);
        make.left.mas_equalTo(_activityLabel.mas_right);
        make.right.mas_equalTo(_backView.right).mas_offset(-SCREEN_WIDTH * 0.0373);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)creatLabelWithText:(NSString *)text AndFont:(UIFont *)font AndTextColor:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = font;
    lab.text = text;
    lab.textColor = color;
    return lab;
}



@end
