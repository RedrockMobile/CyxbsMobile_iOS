//
//  ScheduleDetailCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *ScheduleDetailCollectionViewCellReuseIdentifier;

#pragma mark - ScheduleDetailCollectionViewCell

@interface ScheduleDetailCollectionViewCell : UICollectionViewCell

/// Data sourse
@property (nonatomic, strong) ScheduleCourse *course;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
