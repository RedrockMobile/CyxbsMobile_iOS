//
//  ClassBookCollectionView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/13.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**这个主要用于如果有单击手势等加在CV上
 * 这个类做主要代理
 * 包括一些布局和装饰信息都在这里面
 * 用来减少VC的代码多的问题
 */

#import <UIKit/UIKit.h>

#import "SchoolLessonItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ClassBookCollectionView;

#pragma mark - ClassBookCollectionViewDelegate

@protocol ClassBookCollectionViewDelegate <NSObject>

@required

- (void)classBook:(ClassBookCollectionView *)view didTapEmptyItemAtWeekIndexPath:(NSIndexPath *)weekIndexPath ofRangeIndexPath:(NSIndexPath *)rangeIndexPath;

@end

#pragma mark - ClassBookCollectionView

@interface ClassBookCollectionView : UICollectionView

/// 代理
@property (nonatomic, weak) id <ClassBookCollectionViewDelegate> classBook_delegate;

@end

NS_ASSUME_NONNULL_END
