//
//  DiscoverADs.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**DiscoverADs
 * “发现”广告位所有广告信息合集
 */

#import <Foundation/Foundation.h>

#import "DiscoverAD.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DiscoverADs

@interface DiscoverADs : NSObject

/// 请求状态码 long
@property (nonatomic, copy)NSString *status;

/// 请求简介信息
@property (nonatomic, copy)NSString *netMessage;

/// 所有广告位
@property (nonatomic, copy)NSArray <DiscoverAD *> *ADCollection;

- (instancetype)init NS_UNAVAILABLE;

/// 根据字典传入
- (instancetype)initWithDictionary: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
