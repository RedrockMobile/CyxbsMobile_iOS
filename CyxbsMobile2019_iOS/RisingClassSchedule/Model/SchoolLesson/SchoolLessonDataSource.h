//
//  SchoolLesoonDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SchoolLesson;

@protocol SchoolLessonDataSource <NSObject>

@required

/// 删库
+ (void)deleteAll;

/// 存储
- (void)save;

/// 从wcdb中取出
+ (NSArray <SchoolLesson *> *)aryFromWCDB;

+ (NSArray <SchoolLesson *> *)request:(void (^_Nullable) (SchoolLesson *lesson))requestBlock;

@end

NS_ASSUME_NONNULL_END
