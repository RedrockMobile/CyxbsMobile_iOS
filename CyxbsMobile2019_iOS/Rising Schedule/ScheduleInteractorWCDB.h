//
//  ScheduleInteractorWCDB.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/*
 此类为本地缓存类，可以被SerVice直接调用来缓存，获取，增加，改动，删除数据
 采取一人一类型一数据表的方法，表名为identifier(combineType + sno)
 每个数据表都有绑定的Model，即bindModel，有了bindModel，数据储存和储存数据获取时将会方便很多
 
 数据储存：请求自己和他人的系统课表，以及第一次创建事务时，需要传入有该课程数据的CombineModel以绑定，这
 样有以下几点好处：
 1.直接从CombineModel里面获取identifier为表名，建表
 2.直接将绑定的CombineModel里面的数据存储到本地数据表中
 
 储存数据获取：
 用 getScheduleDataBaseFromSno:type: 方法创建好一个ScheduleInteractorWCDB对象后，可以直接从bindModel中获取到所有已经存储的课程数据
 
 请求自己的系统课程数据和他人的系统课程数据用法类似
 
 而对于自己自定义的事务，多了“增删改”功能，使用方法相比以上稍有不同，就目前看来，自定义事务只运用于用户自己账号的操作，所以“增删改”方法中使用固定表名，即ScheduleCombineCustom + 本地账号sno
 
 详细代码使用请看对应的飞书文档《iOS "掌上重邮"课表业务》
 */

#import <Foundation/Foundation.h>

#import "ScheduleCombineModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleInteractorWCDB

@interface ScheduleInteractorWCDB : NSObject

/// 绑定模型
@property (nonatomic, strong, readonly) ScheduleCombineModel *bindModel;

/// 存储路径（由绑定的模型决定）
@property (nonatomic, readonly, class) NSString *DBPath;

#pragma mark - Method

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/// 本地缓存的第一步：传入一个带有课程数据的CombineModel，试其成为数据表里面的bindModel，并且创建表
/// @param model 带有课程数据的CombineModel
- (instancetype)initWithBindModel:(ScheduleCombineModel *)model;

/// 本地缓存第二步：保存先前绑定的CombineModel的数据（这里是批量缓存，用于系统课表）
- (void)saveData;

/// 加入一类课程
/// @param course 一类课程
+ (void)insertCourse:(ScheduleCourse *)course;

/// 删除一类课程
/// @param course 一类课程
+ (void)deleteCourse:(ScheduleCourse *)course;

/// 删除全部课程（用于保证本地数据库里面不会出现相同的课程，即所有课程需要在再次请求并存入数据库之前调用此方法，清除原先数据）
- (void)deleteAllCourse;

/// 更新一类课程
/// @param course 一类课程
+ (void)updateCourse:(ScheduleCourse *)course;

/// 查看是否存在该表
/// @param tableName 表名
+ (BOOL)tableIsExist:(NSString *)tableName;

/// 查看该表里面是否有数据
- (BOOL)isCache;

/// 根据学号，课表类型找到该表，返回该WCDB
/// @param sno 学号
/// @param type 类型
+ (instancetype)getScheduleDataBaseFromSno:(NSString *)sno Type:(ScheduleCombineType)type;


@end

NS_ASSUME_NONNULL_END
