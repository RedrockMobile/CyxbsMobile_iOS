//
//  JWZXNewsModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWZXSectionNews.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXNewsModel

/**JWZXNewsModel
 * 教务在线新闻模型
 */

@interface JWZXNewsModel : NSObject

/// 教务在线
@property (nonatomic, strong) NSMutableArray <JWZXSectionNews *> *sectionNewsAry;

/// 创建时，指定一个sectionNews，之后使用newsAry去加
/// @param sectionNews 应该为已经请求过的
- (instancetype)initWithRootNews:(JWZXSectionNews *)sectionNews;

/// 请求新的，会给予是不是更多的
/// @param success 成功
/// @param failure 失败
- (void)requestMoreSuccess:(void (^)(BOOL hadMore))success
                   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
