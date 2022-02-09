//
//  DynamicDetailCommentTableCellModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 动态详情页评论列表的动态评论模型
 reply_list属性中装着的是对这个评论的评论回复
 */
@interface DynamicDetailCommentTableCellModel : NSObject
/**  */
//@property (nonatomic,assign) NSInteger sub_comment_id;
/**  动态的id*/
@property (nonatomic, copy) NSString *post_id;
/** 评论id ，用于举报，点赞*/
@property (nonatomic, copy) NSString *comment_id;
/**  该条评论的回复的评论id， 若该评论是一级评论，则为空字符串*/
@property (nonatomic, copy) NSString *reply_id;
/** 头像URL*/
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nick_name;
/**  评论发布时间*/
@property (nonatomic, assign) long int publish_time;
/**  评论的内容*/
@property (nonatomic, copy) NSString *content;
/**  评论中的图片*/
@property(nonatomic, copy) NSArray *pics;
/** 评论者的uid 用于举报 */
@property (nonatomic, copy) NSString *uid;
/**  是否是自己的评论*/
@property (nonatomic,assign) BOOL is_self;
/** 点赞数*/
@property (nonatomic, assign) int praise_count;
/** 是否点赞 */
@property (nonatomic,assign) BOOL is_praised;
/** 被回复人的名称， 如果是一级评论，则为空 */
@property (nonatomic,copy) NSString *from_nickname;
/** 是否有更多的回复, 1代表有， 0代表无， 若该评论是二级评论，则只返回0 */
@property (nonatomic,assign) int has_more_reply;
/**  回复的内容的数组，若该评论为二级评论则一定为0，目前每个一级评论只获取前三个评论*/
@property (nonatomic,strong) NSArray *reply_list;


+ (NSDictionary *)mj_objectClassInArray;

/// 返回当前cell的值
- (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
