//
//  JWZXNewsInformation.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**JWZXNews
 * 教务在线新闻合集
 */

#import <Foundation/Foundation.h>

#import "JWZXNew.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWZXNewsInformation : NSObject

/// 共几页（目前只有1页）
@property (nonatomic) NSUInteger page;

/// 请求状态码
@property (nonatomic, strong)NSNumber *status;

/// 请求状态分析信息
@property (nonatomic, copy)NSString *netMessage;

/// 新闻内容
@property (nonatomic, strong)NSArray <JWZXNew *> *news;

- (instancetype)init NS_UNAVAILABLE;

/// 根据字典创建
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
