//
//  ScheduleMapModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCollectionViewModel.h"
#import "ScheduleCombineItemSupport.h"
#import "ScheduleTimelineSupport.h"
#import "NSIndexPath+Schedule.h"

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleMapModel
 * base layout class
 */

@interface ScheduleMapModel : NSObject {
@protected
    NSMapTable <NSIndexPath *, NSPointerArray *> *_dayMap;
}

/// 设置学号，使map呈现不同效果
@property (nonatomic, copy, nullable) NSString *sno;

/// 最终的布局mapTable，自定调用finishCombine
@property (nonatomic, strong, readonly) NSMapTable <NSIndexPath *, ScheduleCollectionViewModel *> *mapTable;

@property (nonatomic, readonly) ScheduleTimeline *timeline;

/// 纳入到 dayMap 管理，不对model做强引用
/// @param model 加入map管理的model
- (void)combineItem:(ScheduleCombineItem *)model NS_REQUIRES_SUPER;

/// 将 dayMap 转到 mapTable
- (void)finishCombine;

/// 清理掉所有模型
- (void)clear NS_REQUIRES_SUPER;

- (ScheduleCollectionViewModel *)viewModelWithKey:(ScheduleIdentifier *)identifier forCourse:(ScheduleCourse *)course;

//- (ScheduleTimeline *)timelineWithSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
