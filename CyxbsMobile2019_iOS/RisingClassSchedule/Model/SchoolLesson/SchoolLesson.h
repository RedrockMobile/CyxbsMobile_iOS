//
//  SchoolLesson.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**课表重构测试模型
 * 一节课对应的存储内容
 * 采用WCDB
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *SchoolLessonTableName;

#pragma mark - ENUM (SchoolLessonType)

typedef NS_ENUM(NSUInteger, SchoolLessonType) {
    
    /// 自己的课表
    SchoolLessonTypeDefault,
    
    /// 别人的课表
    SchoolLessonTypeMulty,
    
    /// 自定义课表
    SchoolLessonTypeCustom
};

#pragma mark - SchoolLesson

@interface SchoolLesson : NSObject <
    NSCopying
>

// !!!: Save

/// 存储路径，都是一样的
@property (nonatomic, readonly, class) NSString *databasePath;

// !!!: Time

/// 在第几周1-24
@property (nonatomic) NSInteger inSection;

/// 在星期几1-7
@property (nonatomic) NSInteger inWeek;

/// 第几-几节课，中午为4-5，晚上为8-9
@property (nonatomic) NSRange period;

/// week, day，计算属性
@property (nonatomic, readonly) NSIndexPath *weekIndexPath;

// !!!: Source

/// 课程名
@property (nonatomic, copy) NSString *course;
/// 课程别名（以后可能要用到）
@property (nonatomic, copy) NSString *courseNike;

/// 地点
@property (nonatomic, copy) NSString *classRoom;
/// 地点别名（以后可能要用到）
@property (nonatomic, copy) NSString *classRoomNike;

/// 课程号
@property (nonatomic, copy) NSString *courseID;

/// 循环周期
@property (nonatomic, copy) NSString *rawWeek;

/// 选修类型：@“必须" 或 @“选须"
@property (nonatomic, copy) NSString *type;

/// 老师
@property (nonatomic, copy) NSString *teacher;

/// @“xx节”
@property (nonatomic, copy) NSString *lesson;

/// 保存的类型
@property (nonatomic) SchoolLessonType saveType;

#pragma mark - Method

/// 根据字典来赋值
/// @param dic 字典（这里必须看文档，注意使用）
- (instancetype)initWithDictionary:(NSDictionary *)dic;

// !!!: WCDBb

/// 删库
+ (void)deleteAll;

/// 存储
- (void)save;

/// 从wcdb中取出
+ (NSArray <SchoolLesson *> *)aryFromWCDB;

@end

NS_ASSUME_NONNULL_END
