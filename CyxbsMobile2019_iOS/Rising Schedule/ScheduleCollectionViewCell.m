//
//  ScheduleCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewCell.h"

NSString *ScheduleCollectionViewCellReuseIdentifier = @"ScheduleCollectionViewCell";

#pragma mark - ScheduleCollectionViewCell ()

@interface ScheduleCollectionViewCell ()

/// 标题
@property (nonatomic, strong) UILabel *titleLab;

/// 细节
@property (nonatomic, strong) UILabel *contentLab;

@end

#pragma mark - ScheduleCollectionViewCell

@implementation ScheduleCollectionViewCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

#pragma mark - Method

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, CGFLOAT_MIN, CGFLOAT_MIN)];
        _titleLab.numberOfLines = 3;
        _titleLab.font = [UIFont fontWithName:PingFangSC size:10];
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (_contentLab == nil) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.x, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN)];
        _contentLab.numberOfLines = 3;
        _contentLab.font = [UIFont fontWithName:PingFangSC size:10];
    }
    return _contentLab;
}

#pragma mark - Setter

@end
