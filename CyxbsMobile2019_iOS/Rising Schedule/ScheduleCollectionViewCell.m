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
        _drawType = -1;
        self.backgroundColor = UIColor.clearColor;
        self.contentView.layer.cornerRadius = 8;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

#pragma mark - Method

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGRect frame = layoutAttributes.frame;
    
    [self.titleLab stretchRight_toPointX:self.contentView.SuperRight offset:8];
    [self.titleLab sizeToFit];
    
    self.contentLab.width = self.titleLab.width;
    self.contentLab.top = self.titleLab.bottom;
    [self.contentLab sizeToFit];
    self.contentLab.numberOfLines = (self.contentLab.bottom + 8 >= frame.size.height) ? 1 : 3;
    [self.contentLab sizeToFit];
    self.contentLab.bottom = frame.size.height - 8;
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, CGFLOAT_MIN, CGFLOAT_MIN)];
        _titleLab.backgroundColor = UIColor.clearColor;
        _titleLab.numberOfLines = 3;
        _titleLab.font = [UIFont fontWithName:PingFangSC size:10];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (_contentLab == nil) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.x, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN)];
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.numberOfLines = 3;
        _contentLab.font = [UIFont fontWithName:PingFangSC size:10];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

- (NSString *)courseTitle {
    return self.titleLab.text.copy;
}

- (NSString *)courseContent {
    return self.contentLab.text.copy;
}

#pragma mark - Setter

- (void)setCourseTitle:(NSString *)courseTitle {
    self.titleLab.text = courseTitle.copy;
}

- (void)setCourseContent:(NSString *)courseContent {
    self.contentLab.text = courseContent.copy;
}

- (void)setDrawType:(ScheduleCollectionViewCellDrawType)drawType {
    if (_drawType == drawType) {
        return;
    }
    _drawType = drawType;
    
    switch (drawType) {
        /*ScheduleCollectionViewCellDrawMorning*/
        case ScheduleCollectionViewCellDrawMorning: {
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#F9E7D8")
                                  darkColor:UIColorHex("#26FFCCA1")];
            
            self.titleLab.textColor = self.contentLab.textColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#FF8015")
                                  darkColor:UIColorHex("#CCF0F0F2")];
        } break;
            
        /*ScheduleCollectionViewCellDrawAfternoon*/
        case ScheduleCollectionViewCellDrawAfternoon: {
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#F9E3E4")
                                  darkColor:UIColorHex("#26FF979B")];
            
            self.titleLab.textColor = self.contentLab.textColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#FF6262")
                                  darkColor:UIColorHex("#CCF0F0F2")];
        } break;
            
        /*ScheduleCollectionViewCellDrawNight*/
        case ScheduleCollectionViewCellDrawNight: {
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#DDE3F8")
                                  darkColor:UIColorHex("#269BB2FB")];
            
            self.titleLab.textColor = self.contentLab.textColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#4066EA")
                                  darkColor:UIColorHex("#CCF0F0F2")];
        } break;
            
        /*ScheduleCollectionViewCellDrawOthers*/
        case ScheduleCollectionViewCellDrawOthers: {
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#DFF3FC")
                                  darkColor:UIColorHex("#2690DBFB")];
            
            self.titleLab.textColor = self.contentLab.textColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#06A3FC")
                                  darkColor:UIColorHex("#CCF0F0F2")];
        } break;
            
        /*ScheduleCollectionViewCellDrawCustom*/
        case ScheduleCollectionViewCellDrawCustom: {
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#E9ECF0")
                                  darkColor:UIColorHex("#3C4E70")];
            
            self.titleLab.textColor = self.contentLab.textColor =
            [UIColor dm_colorWithLightColor:UIColorHex("#4D4D4D")
                                  darkColor:UIColorHex("#CCF0F0F2")];
        } break;
    }
}

@end
