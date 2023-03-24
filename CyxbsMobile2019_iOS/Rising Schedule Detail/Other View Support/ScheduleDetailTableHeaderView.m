//
//  ScheduleDetailTableHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailTableHeaderView.h"

#import "ScheduleNeedsSupport.h"

#pragma mark - ScheduleDetailTableHeaderView ()

@interface ScheduleDetailTableHeaderView ()

/// label for title
@property (nonatomic, strong) UILabel *titleLab;

/// label for detail
@property (nonatomic, strong) UILabel *detailLab;

/// label for sno
@property (nonatomic, strong) UILabel *snoLab;

/// button for edit
@property (nonatomic, strong) UIButton *editBtn;

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
        [self addSubview:self.editBtn];
    }
    return self;
}

- (void)layoutSubviews {
    self.titleLab.frame = CGRectMake(16, 16, self.width - 2 * 16 - 50, 31);
    self.editBtn.centerY = self.titleLab.centerY;
    self.editBtn.right = self.width - 16;
    self.detailLab.frame = CGRectMake(self.titleLab.left, self.titleLab.bottom + 8, self.titleLab.width, 18);
    
    [self.snoLab sizeToFit];
    self.snoLab.centerY = self.detailLab.centerY;
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

- (UIButton *)editBtn {
    if (_editBtn == nil) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        _editBtn.layer.cornerRadius = _editBtn.height / 2;
        _editBtn.clipsToBounds = YES;
        _editBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:13];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_editBtn addGradientBlueLayer];
        [_editBtn bringSubviewToFront:_editBtn.titleLabel];
        [_editBtn addTarget:self action:@selector(_tapEdit:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.hidden = YES;
    }
    return _editBtn;
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

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    self.editBtn.hidden = !edit;
}

#pragma mark - Method

- (void)_tapEdit:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:editWithButton:)]) {
        [self.delegate tableHeaderView:self editWithButton:btn];
    }
}

@end
