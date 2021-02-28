//
//  TimeTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self BuildUI];
        [self BuildFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)BuildUI {
    ///日期
    if (@available(iOS 11.0, *)) {
        UILabel *dateLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 15] AndTextColor:[UIColor colorNamed:@"MGDLoginTitleColor"]];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;
    } else {
        // Fallback on earlier versions
    }
    
    ///大圆圈
    UIView *bigCircle = [[UIView alloc] init];
    bigCircle.backgroundColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:209/255.0 alpha:1.0];
    [self addSubview:bigCircle];
    _bigCircle = bigCircle;
    
    ///小圆圈
    UIView *smallCircle = [[UIView alloc] init];
    smallCircle.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:252/255.0 alpha:1.0];
    smallCircle.layer.cornerRadius = smallCircle.frame.size.width / 2;
    [_bigCircle addSubview:smallCircle];
    _smallCircle = smallCircle;
    
    ///竖线
    UIView *lineView = [[UIView alloc] init];
    lineView.alpha = 0.5;
    lineView.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:33.0/255.0 blue:209.0/255.0 alpha:1];
    [self addSubview:lineView];
    _lineView = lineView;
    
    ///背景
    UIView *backView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        backView.backgroundColor = [UIColor colorNamed:@"MGDTimeCellBackColor"];
    } else {
        // Fallback on earlier versions
    }
    backView.layer.cornerRadius = 8;
    [self addSubview:backView];
    _backView = backView;
    
    ///志愿服务名字
    VolunteerLabel *volunteerLabel = [[VolunteerLabel alloc] init];
    volunteerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    if (@available(iOS 11.0, *)) {
        volunteerLabel.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
    } else {
        // Fallback on earlier versions
    }
    volunteerLabel.numberOfLines = 0;
    volunteerLabel.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:volunteerLabel];
    _volunteerLabel = volunteerLabel;
    
    ///时长
    if (@available(iOS 11.0, *)) {
        UILabel *timeLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"Impact" size: 30] AndTextColor:[UIColor colorNamed:@"MGDTimeCellHourColor"]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:timeLabel];
        _timeLabel = timeLabel;
    } else {
        // Fallback on earlier versions
    }
    
    ///单位
    if (@available(iOS 11.0, *)) {
        UILabel *unitLabel = [self creatLabelWithText:@"时" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 8] AndTextColor:[UIColor colorNamed:@"MGDTimeCellHourColor"]];
        [_backView addSubview:unitLabel];
        _unitLabel = unitLabel;
    } else {
        // Fallback on earlier versions
    }
    
    ///地区图片
    UIImageView *areaImgaeView = [[UIImageView alloc]init];
    areaImgaeView.image = [UIImage imageNamed:@"地区"];
    [_backView addSubview:areaImgaeView];
    _areaImageView = areaImgaeView;
    
    ///地区文字
    if (@available(iOS 11.0, *)) {
        UILabel *areaLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTextColor:[UIColor colorNamed:@"MGDTimeCellTextColor"]];
        areaLabel.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:areaLabel];
        _areaLabel = areaLabel;
    } else {
        // Fallback on earlier versions
    }
    
    ///组织图片
    UIImageView *groupImgaeView = [[UIImageView alloc]init];
    groupImgaeView.image = [UIImage imageNamed:@"地区"];
    [_backView addSubview:groupImgaeView];
    _groupImageView = groupImgaeView;
    
    ///组织文字
    if (@available(iOS 11.0, *)) {
        UILabel *groupLabel = [self creatLabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTextColor:[UIColor colorNamed:@"MGDTimeCellTextColor"]];
        groupLabel.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:groupLabel];
        _groupLabel = groupLabel;
    } else {
        // Fallback on earlier versions
    }
    
}

- (UILabel *)creatLabelWithText:(NSString *)text AndFont:(UIFont *)font AndTextColor:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = font;
    lab.text = text;
    lab.textColor = color;
    return lab;
}

- (void) BuildFrame {
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0587);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.166);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.136 * 21/51);
    }];
    
    [_bigCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dateLabel.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0062);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0587);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.0293);
    }];
    _bigCircle.layer.cornerRadius = SCREEN_WIDTH * 0.0293 / 2;
    
    [_smallCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(SCREEN_WIDTH * 0.008);
        make.right.bottom.mas_offset(-SCREEN_WIDTH * 0.008);
    }];
    _smallCircle.layer.cornerRadius = SCREEN_WIDTH * 0.0233 / 2;
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bigCircle.mas_bottom);
        make.centerX.mas_equalTo(self.smallCircle);
        make.bottom.mas_equalTo(self.backView).mas_offset(SCREEN_HEIGHT * 0.0037);
        make.width.mas_equalTo(1);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bigCircle.mas_top);
        make.left.mas_equalTo(_lineView).mas_offset(SCREEN_WIDTH * 0.032);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0587);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.8347 * 133/313);
    }];
    
    [_volunteerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0197);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.232);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.092);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0197);
        make.left.mas_equalTo(_volunteerLabel.mas_right);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.0773);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0518);
    }];
    
    [_unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0443);
        make.left.mas_equalTo(_timeLabel.mas_right).mas_offset(2);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0256);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0256 * 11/8);
    }];
    
    [_areaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0961);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.0511);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.024);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.024 * 11/9);
    }];
    
    [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0911);
        make.left.mas_equalTo(_areaImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.016);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.1278 * 18/40);
    }];
    
    [_groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.1268);
        make.left.width.height.mas_equalTo(_areaImageView);
    }];
    
    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.1207);
        make.left.width.height.mas_equalTo(_areaLabel);
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

- (void)layoutBorderToLayer:(UIView *)view {
    CAShapeLayer *border = [CAShapeLayer layer];
    // 线条颜色
    border.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    border.fillColor = nil;

    CGFloat viewHeight = view.frame.size.height;
    CGFloat viewWidth = view.frame.size.width;

    border.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, viewWidth, viewHeight) cornerRadius:view.layer.cornerRadius].CGPath;
    border.frame = view.bounds;
    // 不要设太大 不然看不出效果
    border.lineWidth = 1.0f;
    border.lineCap = @"square";
    // 第一个是 线条长度 第二个是间距 nil时为实线
    border.lineDashPattern = @[@5, @5];
    [view.layer addSublayer:border];
}



@end

