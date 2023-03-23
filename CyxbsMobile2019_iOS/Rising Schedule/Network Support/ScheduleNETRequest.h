//
//  ScheduleNETRequest.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**课表Request业务
 * 可以不创建该业务直接类方法请求不同数据
 * 当你需要使用事务，创建并设置customItem
 * 当然也可以使用全局current或设置它
 */

#import <Foundation/Foundation.h>

#import "ScheduleRequestType.h"

#import "ScheduleCombineItemSupport.h"

NS_ASSUME_NONNULL_BEGIN

@class ScheduleWidgetCache;

@interface ScheduleNETRequest : NSObject

+ (instancetype)current;
@property (nonatomic, strong) ScheduleCombineItem *customItem;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Method

/// 请求课表
/// @param requestDictionary 一种字典，记录如下
/// 1) 个人课表 @{ScheduleModelRequestStudent : @[@"2021215154"]}
/// 2) 多人课表 @{ScheduleModelRequestStudent : @[@"2021215154", @"2021215179"]}
/// 3) 老师课表 @{ScheduleModelRequestTeacher : @[@"040107"]}
/// 4) 混合课表 @{ScheduleModelRequestStudent : @[@"2021215154"], ScheduleModelRequestTeacher : @[@"040107"]}
/// @param success 成功返回
/// @param failure 失败返回
+ (void)request:(ScheduleRequestDictionary *)requestDictionary
        success:(void (^)(ScheduleCombineItem *item))success
        failure:(void (^)(NSError *error, ScheduleIdentifier *errorID))failure;

/// 新增事务
/// @param course 一节自定义课，记录如下
/// 1) 可使用属性: inWeek, inSections, period_location, period_lenth, course, classRoom
/// 2) 自动权属性: type
/// @param success 成功返回
/// @param failure 失败返回
- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success
             failure:(void (^)(NSError *error))failure;

/// 更改事务
/// @param course 一节自定义课，记录如下
/// 1) course必须为原来就拥有的一个模型
/// 2) 若更改了**时间**，则视图应发生变化
/// 3) 自定义检查标识符为courseID
/// @param success 成功返回
/// @param failure 失败返回
- (void)editCustom:(ScheduleCourse *)course
           success:(void (^)(ScheduleCombineItem *item))success
           failure:(void (^)(NSError *error))failure;

/// 删除事务
/// @param course course 一节自定义课，记录如下
/// 1) 自定义检查标识符为customID
/// @param success 成功返回
/// @param failure 失败返回
- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success
             failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
