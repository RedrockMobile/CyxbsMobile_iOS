//
//  ScheduleServiceDelegate.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleRequestType.h"

#import "ScheduleModel.h"

#import "ScheduleHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleServiceDelegate : NSObject <
    UICollectionViewDelegate,
    ScheduleHeaderViewDelegate
>

+ (instancetype)new NS_UNAVAILABLE;

/// request schedule
@property (nonatomic, strong) ScheduleRequestDictionary *parameterIfNeeded;

/// setting datasourse
@property (nonatomic, readonly, nonnull) ScheduleModel *model;

/// comflict collectionView
@property (nonatomic, strong, null_resettable) UICollectionView *collectionView;

- (void)requestAndReloadData;

- (void)scrollToSection:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
