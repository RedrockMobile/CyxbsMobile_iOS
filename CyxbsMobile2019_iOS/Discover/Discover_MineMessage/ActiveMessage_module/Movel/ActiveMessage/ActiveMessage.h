//
//  ActiveMessage.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ActiveMessage

/// 活动消息
@interface ActiveMessage : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 内容，有点多的那种
@property (nonatomic, copy) NSString *content;

/// 作者
@property (nonatomic, copy) NSString *author;

/// 头像来源
@property (nonatomic, copy) NSString *userHeadURL;

/// 日期
@property (nonatomic, copy) NSString *date;

/// 一张简介图
@property (nonatomic, copy) NSString *imgURL;

/// 抵达的URL
@property (nonatomic, copy) NSString *url;

/// 是否已读
@property (nonatomic) BOOL hadRead;

/// 消息唯一 ID
@property (nonatomic) NSInteger msgID;

- (instancetype)init NS_UNAVAILABLE;

/// 根据字典传递初始化
/// @param dic 字典
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
