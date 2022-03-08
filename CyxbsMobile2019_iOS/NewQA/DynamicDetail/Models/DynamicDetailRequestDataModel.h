//
//  DynamicDetailRequestDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *动态详情页用来请求数据的model，包括以下请求：
 *
 *评论点赞
 *
 *请求帖子的详情
 *
 *添加/回复评论
 *
 *举报评论
 *
 *删除评论
 */
@interface DynamicDetailRequestDataModel : NSObject
/// 点赞评论的网络请求
/// @param comment_id 传入的评论的id
/// @param sucess 网络请求成功后的操作
/// @param failure  网络请求失败后的操作
- (void)starCommentWithComent_id:(int)comment_id Sucess:(void(^)(void))sucess Failure:(void(^)(void))failure;

/// 请求具体的动态数据
/// @param dynamic_id 传入的id
/// @param sucess 成功后传出一个字典，进行后续操作
/// @param failure 失败后的操作
- (void)requestDynamicDetailDataWithDynamic_id:(int)dynamic_id Sucess:(void(^)(NSDictionary *dic))sucess Failure:(void(^)(void))failure;


/// 根据帖子的id获取帖子下的评论
/// @param target_id 帖子的id或者一级评论的id
/// @param page 页数，一页是6条
/// @param comment_type 评论的类型，1则是一级评论，2则是二级评论
/// @param sucess 成功后传出数据数组，进行后续操作
/// @param failure 失败后的操作
- (void)getCommentDataWithTarget_id:(int)target_id andPage:(int)page andComent_type:(int)comment_type Sucess:(void(^)(NSArray *commentAry))sucess Failure:(void(^)(void))failure;

///根据id举报评论
/// @param comment_id id
/// @param content 评论的内容
/// @param sucess 成功后的操作
/// @param failure 失败后的操作
- (void)reportCommentWithId:(int)comment_id Content:(NSString *)content Sucess:(void(^)(void))sucess Failure:(void(^)(void))failure;

///根据评论的id删除评论
/// @param post_id 评论的id
/// @param sucess 成功后的操作
/// @param failure 失败后的操作
- (void)deleteCommentWithId:(int)post_id Sucess:(void(^)(void))sucess Failure:(void(^)(void))failure;

///删除动态信息
- (void)deletSelfDynamicWithID:(int)post_id Success:(void(^)(void))success Failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
