//
//  JWZXDetailNewsModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWZXNewsAnnexModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXDetailNewsModel

/// 单个教务新闻模型
@interface JWZXDetailNewsModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 内容
@property (nonatomic, copy) NSString *content;

/// 自己的ID（并非下载附件的ID）
@property (nonatomic, copy) NSString *newsID;

/// 新闻的日期
@property (nonatomic, copy) NSString *date;

/// 附件信息
@property (nonatomic, copy) NSArray <JWZXNewsAnnexModel *> * annexModels;

// MARK: Init

- (instancetype)init NS_UNAVAILABLE;

/// 一个新闻必须确定它的ID
/// @param newsID 新闻的ID，用于网络请求
- (instancetype)initWithNewsID:(NSString *)newsID;

// MARK: Method

- (void)requestNewsSuccess:(void (^)(void))success
                   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
