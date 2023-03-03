//
//  ScheduleCustomEditCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleCustomEditCollectionViewCell.h"

NSString *ScheduleCustomEditCollectionViewCellReuseIdentifier = @"ScheduleCustomEditCollectionViewCell";

#pragma mark - ScheduleCustomEditCollectionViewCell ()

@interface ScheduleCustomEditCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@end

#pragma mark - ScheduleCustomEditCollectionViewCell

@implementation ScheduleCustomEditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        self.contentView.layer.cornerRadius = 8;
        self.contentView.backgroundColor =
        [UIColor Light:UIColorHex(#F2F3F7) Dark:UIColorHex(#2D2D2D)];
        
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.titleLab.size = layoutAttributes.size;
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.backgroundColor =
        [UIColor Light:UIColorHex(#4A44E4) Dark:UIColorHex(#465FFF)];
        self.titleLab.textColor = UIColorHex(#FFFFFF);
    } else {
        self.contentView.backgroundColor =
        [UIColor Light:UIColorHex(#F2F3F7) Dark:UIColorHex(#2D2D2D)];
        self.titleLab.textColor = [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title.copy;
}

#pragma mark - Getter

- (NSString *)title {
    return self.titleLab.text;
}

#pragma mark - Lazy

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = UIColor.clearColor;
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:10];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
        _titleLab.userInteractionEnabled = YES;
    }
    return _titleLab;
}

@end
