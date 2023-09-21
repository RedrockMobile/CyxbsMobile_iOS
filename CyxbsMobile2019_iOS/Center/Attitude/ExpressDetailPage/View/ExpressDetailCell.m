//
//  ExpressDetailCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressDetailCell.h"

@implementation ExpressDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;  // 无黑夜模式
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:0.05];
        [self.contentView addSubview:self.title];
        [self setTitlePosition];
    }
    return self;
}

#pragma mark - Method

/// 选中后的第一步是恢复初始状态
- (void)backToOriginState {
    [self.checkImage removeFromSuperview];
    [self.percent removeFromSuperview];
    [self.gradientView removeFromSuperview];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:0.05];
    self.gradientView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
}

/// 选中的cell的UI情况
- (void)selectCell {
    self.gradientView.backgroundColor = [UIColor colorWithHexString:@"#534EF3" alpha:1.0];
    [self setCheckImagePosition];  // 加入对勾
    self.title.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    self.percent.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#6C68EE" alpha:1.0];
    [self.contentView addSubview:self.gradientView];
    [self addViewsAndPosition];
}

/// 其他cell的UI情况
- (void)otherCell {
    self.gradientView.backgroundColor = [UIColor colorWithHexString:@"#4A44E4" alpha:0.1];
    // 颜色改变
    self.title.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.7];
    self.percent.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.5];
    [self.contentView addSubview:self.gradientView];
    [self addViewsAndPosition];
}

/// title与百分比
- (void)addViewsAndPosition {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.percent];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(36);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-71);
    }];
    
    [self.percent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(27, 17));
    }];
}

/// 对勾图片
- (void)setCheckImagePosition {
    [self.contentView addSubview:self.checkImage];
    [self.checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-51);
        make.size.mas_equalTo(CGSizeMake(17, 14));
    }];
}

- (void)setTitlePosition {
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(36);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-71);
    }];
}

-(void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.origin.y += 20;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 30;
    self.clipsToBounds = YES;
    
    [super setFrame:frame];
}


#pragma mark - Getter

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(36, 16, self.contentView.bounds.size.width - 36 - 78, 20)];
        _title.textColor = [UIColor colorWithHexString:@"#15315B"];
        _title.font = [UIFont fontWithName:PingFangSCRegular size:14];
        // test
        _title.text = @"你是否支持iPhone的接口将要统—接口";
    }
    return _title;
}
- (UIImageView *)checkImage {
    if (_checkImage == nil) {
        _checkImage = [[UIImageView alloc] init];
        _checkImage.image = [UIImage imageNamed:@"Express_vector"];
    }
    return _checkImage;
}
- (UILabel *)percent {
    if (_percent == nil) {
        _percent = [[UILabel alloc] init];
        _percent.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.5];
        _percent.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _percent.textAlignment = NSTextAlignmentLeft;
    }
    return _percent;
}

- (UIView *)gradientView {
    if (_gradientView == nil) {
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    }
    return _gradientView;
}

@end
