//
//  ScheduleEventTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleEventTableViewCell.h"

NSString *ScheduleEventTableViewCellReuseIdentifier = @"ScheduleEventTableViewCell";

@interface ScheduleEventTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UISwitch *chooseSwitch;

@end

@implementation ScheduleEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.chooseSwitch];
    }
    return self;
}

- (void)layoutSubviews {
    [self.titleLab sizeToFit];
    self.titleLab.centerY = self.contentView.height / 2;
    self.titleLab.left = 16;
    
    self.chooseSwitch.centerY = self.titleLab.centerY;
    self.chooseSwitch.right = self.contentView.width - 16;
}

#pragma mark - Private

- (void)_tapSwitch:(UISwitch *)swi {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didResponseSwitch:)]) {
        [self.delegate tableViewCell:self didResponseSwitch:swi];
    }
}

#pragma mark - Lazy

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:15];
        _titleLab.textColor =
        [UIColor Light:UIColorHex(#112C54)
                  Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UISwitch *)chooseSwitch {
    if (_chooseSwitch == nil) {
        _chooseSwitch = [[UISwitch alloc] init];
        _chooseSwitch.onTintColor = UIColorRGBA255(42, 33, 209, 1);
        _chooseSwitch.subviews.firstObject.subviews.firstObject.backgroundColor =
        [UIColor Light:UIColorHex(#C3D4EE) Dark:UIColorHex(#5A5A5A)];
        [_chooseSwitch addTarget:self action:@selector(_tapSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _chooseSwitch;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title;
    [self.titleLab sizeToFit];
}

- (NSString *)title {
    return self.titleLab.text;
}

- (void)setSwitchOn:(BOOL)switchOn {
    [self.chooseSwitch setOn:switchOn animated:YES];
}

- (BOOL)switchOn {
    return self.chooseSwitch.on;
}

@end
