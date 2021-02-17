//
//  MineQAMyQuestionItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//我的提问Model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyQuestionItem : NSObject

/// 问题ID
@property (nonatomic, copy) NSString *questionID;

/// 问题标题
@property (nonatomic, copy) NSString *title;

/// 问题内容
@property (nonatomic, copy) NSString *questionContent;

/// 悬赏积分数
@property (nonatomic, copy) NSString *integral;

/// 可能是   “是否已解决”
@property (nonatomic, copy) NSString *type;

/// 时间戳
@property (nonatomic, copy) NSString *disappearTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
