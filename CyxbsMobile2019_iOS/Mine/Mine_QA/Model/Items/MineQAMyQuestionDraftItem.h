//
//  MineQAMyQuestionDraftItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyQuestionDraftItem : NSObject

/// 问题草稿ID
@property (nonatomic, copy) NSString *questionDraftID;
/// 问题草稿标题
@property (nonatomic, copy) NSString *title;
/// 问题草稿内容
@property (nonatomic, copy) NSString *questionDraftContent;
/// 问题草稿最后一次编辑的时间
@property (nonatomic, copy) NSString *lastEditTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
