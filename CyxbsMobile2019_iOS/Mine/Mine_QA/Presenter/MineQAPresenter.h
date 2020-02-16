//
//  MineQAPresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineQAProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class MineQAModel;
@interface MineQAPresenter : NSObject

@property (nonatomic, strong) UIViewController<MineQAProtocol> *view;
@property (nonatomic, strong) MineQAModel *model;

- (void)attachView:(UIViewController<MineQAProtocol> *)view;
- (void)dettachView;

/// 请求我的提问列表
- (void)requestQuestionsListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

/// 请求我的提问草稿箱列表
- (void)requestQuestionsDraftListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

/// 请求我的回答列表
- (void)requestAnswerListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

/// 请求我的回答草稿箱列表
- (void)requestAnswerDraftListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

/// 请求我发出的评论列表
- (void)requestCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

/// 请求我收到的评论列表
- (void)requestReCommentListWithPageNum:(NSNumber *)pageNum andSize:(NSNumber *)size;

@end

NS_ASSUME_NONNULL_END
