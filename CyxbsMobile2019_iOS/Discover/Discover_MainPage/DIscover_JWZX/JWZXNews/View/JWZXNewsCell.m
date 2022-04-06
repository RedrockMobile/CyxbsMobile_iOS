//
//  JWZXNewsCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "JWZXNewsCell.h"
#define ColorHaveFile  [UIColor colorNamed:@"ColorHaveFile" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsTime  [UIColor colorNamed:@"ColorNewsTime" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsCellTitle  [UIColor colorNamed:@"ColorNewsCellTitle" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorSeperateLine  [UIColor colorNamed:@"ColorSeperateLine" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#pragma mark - JWZXNewsCell ()

@interface JWZXNewsCell ()

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UIView *seperateLine;

@end

#pragma mark - JWZXNewsCell

@implementation JWZXNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self addSubview:self.timeLab];
        [self addSubview:self.detailLab];
        [self addSubview:self.seperateLine];
        [self NewsCell_laySubviews];
    }
    return self;
}

#pragma mark - Getter

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = ColorNewsTime;
        _timeLab.font = [UIFont fontWithName:PingFangSCBold size:16];
    }
    return _timeLab;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = ColorNewsCellTitle;
        _detailLab.font = [UIFont fontWithName:PingFangSCRegular size:18];
    }
    return _detailLab;
}

- (UIView *)seperateLine {
    if (_seperateLine == nil) {
        _seperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        _seperateLine.backgroundColor = ColorSeperateLine;
    }
    return _seperateLine;;
}

#pragma mark - Method

- (void)showNewsWithTimeString:(NSString *)timeStr withDetail:(NSString *)detailStr {
    self.timeLab.text = timeStr;
    self.detailLab.text = detailStr;
}

- (void)NewsCell_laySubviews {
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(11);
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab);
        make.top.equalTo(self.timeLab.mas_bottom).offset(11);
        make.right.lessThanOrEqualTo(self).offset(-15);
    }];
}

@end
