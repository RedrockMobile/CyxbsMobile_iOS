//
//  AttitudeMainDefaultView.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AttitudeMainDefaultView.h"
@interface AttitudeMainDefaultView()

@property (nonatomic, strong) UIImageView *defaultView;
@property (nonatomic, strong) UILabel *defaultLabel;

@end

@implementation AttitudeMainDefaultView

- (instancetype)initWithDefaultPage {
    if (self) {
        self = [super init];
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
        [self addSubview:self.defaultView];
        [self addSubview:self.defaultLabel];
        [self setPosition];
    }
    return self;
}

- (UIImageView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[UIImageView alloc] init];
        _defaultView.image = [UIImage imageNamed:@"Attitude_defaultPage"];
    }
    return _defaultView;
}

- (UILabel *)defaultLabel {
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.text = @"菌似乎还没有发布过话题,点击右上角去发布吧!";
        _defaultLabel.font = [UIFont fontWithName:PingFangSC size:16];
        _defaultLabel.textColor = [UIColor colorWithHexString:@"#112C54" alpha:0.6];
        _defaultLabel.numberOfLines = 0;
    }
    return _defaultLabel;
}

- (void)setPosition {
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(135);
        make.width.equalTo(@170);
        make.height.equalTo(@102);
    }];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.defaultView.mas_bottom).mas_offset(16);
        make.height.equalTo(@50);
        make.width.equalTo(@201);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
