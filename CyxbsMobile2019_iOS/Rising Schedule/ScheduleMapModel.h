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

#import "NSIndexPath+Schedule.h"

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleMapModel
 * base layout class
 */

@interface ScheduleMapModel : NSObject

/// 设置学号，使map呈现不同效果
@property (nonatomic, copy, nullable) NSString *sno;

/// 最终的布局mapTable，自定调用finishCombine
@property (nonatomic, strong, readonly) NSMapTable <NSIndexPath *, ScheduleCollectionViewModel *> *mapTable;

/// 加入到Map管理，不做强保存
/// @param model 加入map管理的model
- (void)combineItem:(ScheduleCombineItem *)model NS_REQUIRES_SUPER;

- (void)finishCombine;

/// 清理掉所有模型
- (void)clear NS_REQUIRES_SUPER;

@end

@interface ScheduleMapModel (widget)

@property (nonatomic, readonly) NSMapTable <NSIndexPath *, NSPointerArray *> *dayMap;

@end

NS_ASSUME_NONNULL_END
