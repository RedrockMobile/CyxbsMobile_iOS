//
//  ScheduleDetailMessageTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailMessageTableViewCell.h"

NSString *ScheduleDetailMessageTableViewCellReuseIdentifier = @"ScheduleDetailMessageTableViewCellReuseIdentifier";

#pragma mark - ScheduleDetailMessageTableViewCell ()

@interface ScheduleDetailMessageTableViewCell ()

/// left label
@property (nonatomic, strong) UILabel *leftLab;

/// right label
@property (nonatomic, strong) UILabel *rightLab;

@end

#pragma mark - ScheduleDetailMessageTableViewCell

@implementation ScheduleDetailMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.rightLab];
    }
    return self;
}

- (void)layoutSubviews {
    self.rightLab.size = self.leftLab.size = CGSizeMake(self.contentView.width / 2, self.contentView.height);
    
    self.leftLab.left = 16;
    self.rightLab.right = self.contentView.SuperRight - 16;
}

- (NSString *)leftDescription {
    return self.leftLab.text.copy;
}

- (NSString *)rightDetail {
    return self.rightLab.text.copy;
}

#pragma mark - Getter

- (UILabel *)leftLab {
    if (_leftLab == nil) {
        _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width / 2, self.contentView.height)];
        _leftLab.font = [UIFont fontWithName:PingFangSC size:15];
        _leftLab.textColor =
        [UIColor Light:UIColorHex(#112C54)
                  Dark:UIColorHex(#F0F0F2)];
    }
    return _leftLab;
}

- (UILabel *)rightLab {
    if (_rightLab == nil) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(self.leftLab.right, 0, self.contentView.width / 2, self.contentView.height)];
        _rightLab.font = [UIFont fontWithName:PingFangSCBold size:15];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.textColor =
        [UIColor Light:UIColorHex(#112C54)
                  Dark:UIColorHex(#F0F0F2)];
    }
    return _rightLab;
}

- (void)setLeftDescription:(NSString *)leftDescription {
    self.leftLab.text = leftDescription.copy;
}

- (void)setRightDetail:(NSString *)rightDetail {
    self.rightLab.text = rightDetail.copy;
}

@end
