//
//  SchoolBusProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SchoolBusItem;

@protocol SchoolBusProtocol <NSObject>

/// 校车位置加载成功
/// @param busArray 返回的校车对象数组
- (void)schoolBusLocationRequestsSuccess:(NSArray<SchoolBusItem *> *)busArray;

/// 校车位置加载失败
- (void)schoolBusLocationRequestsFailure;

@end

NS_ASSUME_NONNULL_END
