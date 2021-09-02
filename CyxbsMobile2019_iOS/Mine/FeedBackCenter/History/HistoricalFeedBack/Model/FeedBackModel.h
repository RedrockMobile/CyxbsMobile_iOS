//
//  FeedBackModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 每一个 model 对应一个反馈
 */
@interface FeedBackModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) long date;
/// 是否收到回复
@property (nonatomic, assign) BOOL isReplied;
/// 用户是否阅读了这条反馈的回复
@property (nonatomic, assign) BOOL isRead;

/// 网络请求
/// @param success 成功之后执行的block
/// @param failure 失败之后,返回字符串
+ (void)getDataArySuccess:(void (^)(NSArray * array))success
                  failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
