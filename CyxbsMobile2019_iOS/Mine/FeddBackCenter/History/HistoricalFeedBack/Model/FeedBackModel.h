//
//  FeedBackModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedBackModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) long date;
/// 是否收到回复
@property (nonatomic, assign) BOOL isReplied;
/// 用户是否阅读了这条反馈的回复
@property (nonatomic, assign) BOOL isRead;

+ (NSArray *)getFeedBackAry;

@end

NS_ASSUME_NONNULL_END
