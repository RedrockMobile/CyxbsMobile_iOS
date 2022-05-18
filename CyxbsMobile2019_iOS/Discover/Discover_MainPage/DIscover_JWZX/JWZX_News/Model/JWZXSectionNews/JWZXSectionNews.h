//
//  JWZXSectionNews.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWZXNew.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXSectionNews

@interface JWZXSectionNews : NSObject

/// 页码
@property (nonatomic, readonly) NSInteger page;

/// 当页的新闻
@property (nonatomic, copy) NSArray <JWZXNew *> *newsAry;

- (instancetype)init NS_UNAVAILABLE;

/// 必须一页，不一定有值
/// @param page 当页
/// @param success 成功，但有没有值的情况
/// @param failure 失败
+ (void)requestWithPage:(NSInteger)page
                success:(void (^)(JWZXSectionNews  * _Nullable sectionNews))success
                failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
