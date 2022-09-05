//
//  ScheduleCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ENUM(ScheduleCollectionViewCellDrawType)

typedef NS_ENUM(NSUInteger, ScheduleCollectionViewCellDrawType) {
    ScheduleCollectionViewCellDrawMorning,   // 早上
    ScheduleCollectionViewCellDrawAfternoon, // 下午
    ScheduleCollectionViewCellDrawNight,     // 晚上
    ScheduleCollectionViewCellDrawOthers,    // 他人
    ScheduleCollectionViewCellDrawCustom     // 事务
};

/// 复用标志
FOUNDATION_EXPORT NSString *ScheduleCollectionViewCellReuseIdentifier;

#pragma mark - ScheduleCollectionViewCell

@interface ScheduleCollectionViewCell : UICollectionViewCell

/// 绘制类型
@property (nonatomic) ScheduleCollectionViewCellDrawType drawType;

@end

NS_ASSUME_NONNULL_END
