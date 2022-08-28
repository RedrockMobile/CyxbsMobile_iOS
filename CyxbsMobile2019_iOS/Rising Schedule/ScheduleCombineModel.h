//
//  ScheduleCombineModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**
 * 利用这个模型，在多人查询，可以特别特别快的展示出数据，
 * 实现用户对视觉感知度的提升，性能也能达到不重复请求解决问题
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ScheduleCombineType;

@interface ScheduleCombineModel : NSObject

/// 学号，可以确定唯一性
@property (nonatomic, copy) NSString *sno;

/// 绑定类型
@property (nonatomic) ScheduleCombineType combineType;

@end

FOUNDATION_EXPORT ScheduleCombineType ScheduleCombineSystem;

FOUNDATION_EXPORT ScheduleCombineType ScheduleCombineCustom;

NS_ASSUME_NONNULL_END
