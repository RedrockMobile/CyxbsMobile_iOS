//
//  JWZXNewsCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "JWZXNewsCell.h"

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
        
        _timeLab.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#294169" alpha:0.7]
                              darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        
        _timeLab.font = [UIFont fontWithName:PingFangSCBold size:16];
    }
    return _timeLab;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] init];
        
        _detailLab.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        
        _detailLab.font = [UIFont fontWithName:PingFangSCRegular size:18];
    }
    return _detailLab;
}

- (UIView *)seperateLine {
    if (_seperateLine == nil) {
        _seperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        
        _seperateLine.backgroundColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#BDCCE5" alpha:0.3] darkColor:[UIColor colorWithHexString:@"#676767" alpha:0.1]];
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
