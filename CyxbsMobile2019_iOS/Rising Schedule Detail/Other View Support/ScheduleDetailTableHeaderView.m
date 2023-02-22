//
//  ScheduleDetailTableHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailTableHeaderView.h"

#pragma mark - ScheduleDetailTableHeaderView ()

@interface ScheduleDetailTableHeaderView ()

/// label for title
@property (nonatomic, strong) UILabel *titleLab;

/// label for detail
@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UILabel *snoLab;

@end

#pragma mark - ScheduleDetailTableHeaderView

@implementation ScheduleDetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 80;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.detailLab];
        [self addSubview:self.snoLab];
    }
    return self;
}

- (void)layoutSubviews {
    self.titleLab.frame = CGRectMake(16, 16, self.width - 2 * 16, 31);
    self.detailLab.frame = CGRectMake(self.titleLab.left, self.titleLab.bottom + 8, self.titleLab.width, 18);
    
    [self.snoLab sizeToFit];
    self.snoLab.bottom = self.titleLab.bottom;
    self.snoLab.right = self.width - 16;
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:22];
        _titleLab.textColor =
        [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:13];
        _detailLab.textColor =
        [UIColor Light:UIColorHex(#15315BB2)
                  Dark:UIColorHex(#F0F0F080)];
    }
    return _detailLab;
}

- (UILabel *)snoLab {
    if (_snoLab == nil) {
        _snoLab = [[UILabel alloc] init];
        _snoLab.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:13];
        _snoLab.textColor =
        [UIColor Light:UIColorHex(#15315BB2)
                  Dark:UIColorHex(#F0F0F080)];
    }
    return _snoLab;
}

- (NSString *)title {
    return self.titleLab.text.copy;
}

- (NSString *)detail {
    return self.detailLab.text.copy;
}

- (NSString *)sno {
    return self.snoLab.text.copy;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title.copy;
}

- (void)setDetail:(NSString *)detail {
    self.detailLab.text = detail.copy;
}

- (void)setSno:(NSString *)sno {
    self.snoLab.text = sno.copy;
}

@end
