//
//  ScheduleInteractorWCDB.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleInteractorWCDB

@interface ScheduleInteractorWCDB : NSObject

/// 存储路径，都是一样的
@property (nonatomic, readonly, class) NSString *DBPath;

/// 表名
@property (nonatomic, readonly, class) NSString *tableName;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
