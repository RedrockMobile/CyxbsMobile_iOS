//
//  ScheduleLeadingHolderCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleLeadingHolderCollectionViewCell.h"

NSString *ScheduleLeadingHolderCollectionViewCellReuseIdentifier = @"ScheduleLeadingHolderCollectionViewCell";

#pragma mark - ScheduleLeadingHolderCollectionViewCell ()

@interface ScheduleLeadingHolderCollectionViewCell ()

@property (nonatomic, strong) UIImageView *holderImgView;

@end

#pragma mark - ScheduleLeadingHolderCollectionViewCell

@implementation ScheduleLeadingHolderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.holderImgView];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.holderImgView.size = layoutAttributes.size;
}

#pragma mark - Lazy

- (UIImageView *)holderImgView {
    if (_holderImgView == nil) {
        _holderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule.zhizhen"]];
    }
    return _holderImgView;
}

- (void)setMarkingHolder:(ScheduleLeadingHolderMarking)markingHolder {
    switch (markingHolder) {
        case ScheduleLeadingHolderMarkingZhizhen:
            self.holderImgView.image = [UIImage imageNamed:@"schedule.zhizhen"];
            break;
        default: break;
//        case ScheduleLeadingHolderMarkingContracted:
//            <#code#>
//            break;
//        case ScheduleLeadingHolderMarkingOutstretched:
//            <#code#>
//            break;
    }
}

@end
