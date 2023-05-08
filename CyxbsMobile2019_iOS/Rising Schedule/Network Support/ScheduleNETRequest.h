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
#import "ScheduleType.h"

NS_ASSUME_NONNULL_BEGIN

@class ScheduleCombineItem, ScheduleIdentifier, ScheduleCourse;
@protocol ScheduleRequestDelegate;

#pragma mark - ScheduleNETRequest

@interface ScheduleNETRequest : NSObject

@property (nonatomic, strong, nonnull, class) ScheduleNETRequest *current;

@property (nonatomic, strong, nonnull) ScheduleCombineItem *customItem;

@property (nonatomic, weak) id <ScheduleRequestDelegate> delegate;

@property (nonatomic) NSTimeInterval outRequestTime;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end



#pragma mark - ScheduleNETRequest (Network)

@interface ScheduleNETRequest (Network)

/// 请求课表
/// @param requestDictionary 一种字典，记录如下
/// 1) 个人课表 @{ScheduleModelRequestStudent : @[@"2021215154"]}
/// 2) 多人课表 @{ScheduleModelRequestStudent : @[@"2021215154", @"2021215179"]}
/// 3) 老师课表 @{ScheduleModelRequestTeacher : @[@"040107"]}
/// 4) 混合课表 @{ScheduleModelRequestStudent : @[@"2021215154"], ScheduleModelRequestTeacher : @[@"040107"]}
/// @param success 成功返回
/// @param failure 失败返回
+ (void)requestDic:(ScheduleRequestDictionary *)requestDictionary
           success:(void (^)(ScheduleCombineItem *item))success
           failure:(void (^)(NSError *error, ScheduleIdentifier *errorID))failure;

+ (void)requestKeys:(NSArray <ScheduleIdentifier *> *)keys
            success:(void (^)(ScheduleCombineItem *item))success
            failure:(void (^)(NSError *error, ScheduleIdentifier *errorID))failure;

@end



#pragma mark - ScheduleRequestDelegate

@protocol ScheduleRequestDelegate <NSObject>

@optional

- (BOOL)request:(ScheduleNETRequest *)request useMemEmptyItemWithDiskKey:(ScheduleIdentifier *)key;

@end



#pragma mark - ScheduleNETRequest (Policy)

@interface ScheduleNETRequest (Policy)

- (void)policyKeys:(NSArray <ScheduleIdentifier *> *)keys
           success:(void (^)(ScheduleCombineItem *item))success
           failure:(void (^)(NSError *error, ScheduleIdentifier *errorID))failure;

- (void)policyCustom:(ScheduleIdentifier *)cKey
             success:(void (^)(ScheduleCombineItem *item))success;

- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success;

- (void)editCustom:(ScheduleCourse *)course
           success:(void (^)(ScheduleCombineItem *item))success;

- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *item))success;

@end

NS_ASSUME_NONNULL_END
