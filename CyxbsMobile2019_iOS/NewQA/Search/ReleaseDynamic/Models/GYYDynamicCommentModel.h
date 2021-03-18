//
//  GYYDynamicCommentModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//  动态评论模型

#import <Foundation/Foundation.h>
@class GYYSecondLevelCommentModel;

NS_ASSUME_NONNULL_BEGIN

@interface GYYDynamicCommentModel : NSObject
/**  */
@property (nonatomic,copy) NSString *avatar;
/**  */
@property (nonatomic,assign) NSInteger comment_id;
/**  */
//@property (nonatomic,assign) NSInteger sub_comment_id;
/**  */
@property (nonatomic,copy) NSString *content;
/** 被回复名称 */
@property (nonatomic,copy) NSString *from_nickname;
/**  */
@property (nonatomic,assign) BOOL has_more_reply;
/** 是否点赞 */
@property (nonatomic,assign) BOOL is_praised;
/**  */
@property (nonatomic,assign) BOOL is_self;
/**  */
@property (nonatomic,copy) NSString *nick_name;
/**  */
@property (nonatomic,assign) NSInteger post_id;
/** 回复点赞数 */
@property (nonatomic,copy) NSString *praise_count;
/**  */
@property (nonatomic,copy) NSString *publish_time;
/**  */
@property (nonatomic,assign) NSInteger reply_id;
/**  */
@property (nonatomic,strong) NSArray *reply_list;
/** 用于举报 */
@property (nonatomic,assign) NSString *uid;
/**  */
@property(nonatomic, strong) NSArray *pics;
@end

NS_ASSUME_NONNULL_END
