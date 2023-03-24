//
//  ScheduleDetailCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleDetailPartContext.h"

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *ScheduleDetailCollectionViewCellReuseIdentifier;

@class ScheduleDetailCollectionViewCell;

#pragma mark - ScheduleDetailCollectionViewCellDelegate

@protocol ScheduleDetailCollectionViewCellDelegate <NSObject>

@optional

- (void)collectionViewCell:(ScheduleDetailCollectionViewCell *)cell editWithButton:(UIButton *)btn;

@end

#pragma mark - ScheduleDetailCollectionViewCell

@interface ScheduleDetailCollectionViewCell : UICollectionViewCell

/// Data sourse
@property (nonatomic, strong) ScheduleDetailPartContext *context;

@property (nonatomic, weak) id <ScheduleDetailCollectionViewCellDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
