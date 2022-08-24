//
//  ScheduleInteractorRequest.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**课表Request业务
 * 创建该业务并绑定所需业务模型
 * 利用该业务进行网络CRUD行为
 * 禁止在绑定后指定其他绑定对象
 */

#import <Foundation/Foundation.h>

#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ScheduleModelRequestType;

#pragma mark - ScheduleInteractorRequest

@interface ScheduleInteractorRequest : NSObject

/// 绑定模型
@property (nonatomic, readonly) ScheduleModel *bindModel;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/// 根据绑定模型创建该业务
/// @param model 被绑定的模型
+ (instancetype)requestBindingModel:(ScheduleModel *)model;

#pragma mark - Method

/// 请求数据
/// @param requestDictionary 一种字典，记录如下
/// 1) 个人课表 @{student : @[@"2021215154"]}
/// 2) 多人课表 @{student : @[@"2021215154", @"2021215179"]}
/// 3) 老师课表 @{teacher : @[@"040107"]}
/// 4) 混合课表 @{student : @[@"2021215154"], teacher : @[@"040107"]}
/// @param success 成功返回
/// @param failure 失败返回
- (void)request:(NSDictionary
                 <ScheduleModelRequestType, NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(void))success
        failure:(void (^)(NSError *error))failure;

@end

#pragma mark - ScheduleModelRequestType

/// 学生
FOUNDATION_EXPORT ScheduleModelRequestType student;

/// 老师
FOUNDATION_EXPORT ScheduleModelRequestType teacher;

/// 自定义
FOUNDATION_EXPORT ScheduleModelRequestType custom __deprecated_msg("待测试接口");

NS_ASSUME_NONNULL_END
