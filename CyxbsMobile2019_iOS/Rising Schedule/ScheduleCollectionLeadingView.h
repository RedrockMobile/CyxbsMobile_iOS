//
//  ScheduleCollectionLeadingView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *ScheduleCollectionLeadingViewReuseIdentifier;

#pragma mark - ScheduleCollectionLeadingView

@interface ScheduleCollectionLeadingView : UICollectionReusableView

/// 列间距
@property (nonatomic) CGFloat lineSpacing;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
