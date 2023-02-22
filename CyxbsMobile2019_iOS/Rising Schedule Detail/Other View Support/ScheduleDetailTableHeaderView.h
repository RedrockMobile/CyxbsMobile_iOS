//
//  ScheduleDetailTableHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleDetailTableHeaderView

@interface ScheduleDetailTableHeaderView : UIView

/// title
@property (nonatomic, copy) NSString *title;

/// detail
@property (nonatomic, copy) NSString *detail;

/// sno
@property (nonatomic, copy) NSString *sno;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
