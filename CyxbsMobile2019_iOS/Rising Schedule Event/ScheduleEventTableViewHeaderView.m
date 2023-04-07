//
//  ScheduleEventTableViewHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleEventTableViewHeaderView.h"

NSString *ScheduleEventTableViewHeaderViewReuseIdentifier = @"ScheduleEventTableViewHeaderView";

@interface ScheduleEventTableViewHeaderView ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *toBtn;

@end

@implementation ScheduleEventTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.toBtn];
    }
    return self;
}

@end
