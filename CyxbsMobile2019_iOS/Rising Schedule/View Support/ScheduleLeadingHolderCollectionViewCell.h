//
//  ScheduleLeadingHolderCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *ScheduleLeadingHolderCollectionViewCellReuseIdentifier;

typedef NS_ENUM(NSUInteger, ScheduleLeadingHolderMarking) {
    ScheduleLeadingHolderMarkingZhizhen, // ●——
    ScheduleLeadingHolderMarkingContracted, // >
    ScheduleLeadingHolderMarkingOutstretched, // ⋁
};

@interface ScheduleLeadingHolderCollectionViewCell : UICollectionViewCell

@property (nonatomic) ScheduleLeadingHolderMarking markingHolder;

@end

NS_ASSUME_NONNULL_END
