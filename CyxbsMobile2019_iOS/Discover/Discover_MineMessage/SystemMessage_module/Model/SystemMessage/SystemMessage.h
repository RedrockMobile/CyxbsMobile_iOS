//
//  SystemMessage.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MineMessage

/// 一条我的消息类型
@interface SystemMessage : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 细节
@property (nonatomic, copy) NSString *content;

/// 日期
@property (nonatomic, copy) NSString *date;

/// 到达的URL
@property (nonatomic, copy) NSString *url;

/// 是否已读
@property (nonatomic) BOOL hadRead;

/// 消息唯一ID
@property (nonatomic) NSInteger msgID;

- (instancetype)init NS_UNAVAILABLE;

/// 根据字典创建次类型
/// @param dic 字典
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
