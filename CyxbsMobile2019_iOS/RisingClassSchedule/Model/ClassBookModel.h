//
//  ClassBookModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SchoolLesson.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ENUM (ClassBookRequestType)

typedef NS_ENUM(NSUInteger, ClassBookRequestType) {
    ClassBookRequestStudent,
    ClassBookRequestTeacher
};

#pragma mark - ClassBookModel

@interface ClassBookModel : NSObject

/// 开始的时间
@property (nonatomic, readonly) NSDate *startDate;

/// 当周
@property (nonatomic, readonly) NSUInteger nowWeek;

/// 多课表hash取值法
@property (nonatomic, strong) NSMutableDictionary
<NSIndexPath *, NSMutableDictionary
        <NSIndexPath *, NSMutableArray
                    <SchoolLesson *> *> *> *hashDic;

@property (nonatomic, strong) NSArray
<NSMutableDictionary
    <NSIndexPath *, NSMutableArray
        <SchoolLesson *> *> *> *model;

#pragma mark - 换个思路？

- (void)requestType:(ClassBookRequestType)requestType
                num:(NSString *)num
            success:(void (^)(void))success
            failure:(void (^)(NSError *error))failure;

/// 是否需要WCDB
@property (nonatomic) BOOL needSave;

/// 用于是否多人是重写字典
@property (nonatomic) BOOL needReset;

#pragma mark - Method

/// 从WCDB中加载
- (void)readFromWCDB;

/// 请求学生的课表
/// @param stu_Num 学生学号
/// @param success 成功
/// @param failure 失败
- (void)requestWithNum:(NSString *)stu_Num
               success:(void (^)(void))success
               failure:(void (^)(NSError *error))failure;

- (void)requestWithTeacher:(NSString *)tea_Num
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *error))failure;

- (NSArray <SchoolLesson *> *)aryForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
