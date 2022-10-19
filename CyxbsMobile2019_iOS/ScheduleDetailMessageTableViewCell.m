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

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.rightLab];
    }
    return self;
}

#pragma mark - Getter


@end
