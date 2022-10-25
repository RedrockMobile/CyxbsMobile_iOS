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

@end

#pragma mark - ScheduleDetailTableHeaderView

@implementation ScheduleDetailTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 80;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.detailLab];
    }
    return self;
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, self.width - 2 * 16, 31)];
        _titleLab.font = [UIFont fontWithName:PingFangSCBold size:22];
        _titleLab.textColor =
        [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom + 8, self.titleLab.width, 18)];
        _detailLab.font = [UIFont fontWithName:PingFangSC size:13];
        _detailLab.textColor =
        [UIColor Light:UIColorHex(#15315BB2)
                  Dark:UIColorHex(#F0F0F080)];
    }
    return _detailLab;
}

- (NSString *)title {
    return self.titleLab.text.copy;
}

- (NSString *)detail {
    return self.detailLab.text.copy;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title.copy;
}

- (void)setDetail:(NSString *)detail {
    self.detailLab.text = detail.copy;
}

@end
