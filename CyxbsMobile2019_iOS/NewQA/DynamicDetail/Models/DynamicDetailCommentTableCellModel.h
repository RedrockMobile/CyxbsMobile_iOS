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
/** 头像 */
@property (nonatomic,copy) NSString *avatar;
/** 评论id ，用于举报，点赞*/
@property (nonatomic,assign) int comment_id;
/**  */
//@property (nonatomic,assign) NSInteger sub_comment_id;
/**  评论的内容*/
@property (nonatomic,copy) NSString *content;
/** 被回复名称 */
@property (nonatomic,copy) NSString *from_nickname;
/** 是否有更多的回复 */
@property (nonatomic,assign) BOOL has_more_reply;
/** 是否点赞 */
@property (nonatomic,assign) BOOL is_praised;
/**  是否是自己的评论*/
@property (nonatomic,assign) BOOL is_self;
/** 昵称 */
@property (nonatomic,copy) NSString *nick_name;
/**  动态的id*/
@property (nonatomic,assign) int post_id;
/** 回复点赞数 */
@property (nonatomic,copy) NSString *praise_count;
/**  评论发布时间*/
@property (nonatomic,copy) NSString *publish_time;
/**  回复的id*/
@property (nonatomic,assign) NSInteger reply_id;
/**  回复的内容的数组*/
@property (nonatomic,strong) NSArray *reply_list;
/** 用于举报 */
@property (nonatomic,assign) NSString *uid;
/**  评论中的图片*/
@property(nonatomic, strong) NSArray *pics;

+ (NSDictionary *)mj_objectClassInArray;

/// 返回当前cell的值
- (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
