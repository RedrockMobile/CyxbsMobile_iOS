//
//  SchoolLessonDateView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *SchoolLessonDateViewReuseIdentifier;

#pragma mark - SchoolLessonDateView

@interface SchoolLessonDateView : UICollectionReusableView

- (instancetype)init NS_UNAVAILABLE;

/// 绘制
/// @param week 星期
/// @param day 几号
/// @param isCurrent 是否current
- (void)withWeek:(NSString *)week day:(NSString *)day isCurrent:(BOOL)isCurrent;

@end

NS_ASSUME_NONNULL_END
