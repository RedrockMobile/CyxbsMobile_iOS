//
//  PostItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostItem : NSObject <NSCoding>

///帖子唯一id
@property (nonatomic, strong) NSString *post_id;

///头像
@property (nonatomic, strong) NSString *avatar;

///昵称
@property (nonatomic, strong) NSString *nick_name;

///时间戳
@property (nonatomic, strong) NSNumber *publish_time;

///帖子内容
@property (nonatomic, strong) NSString *content;

///图片数组
@property (nonatomic, strong) NSArray *pics;

///圈子名
@property (nonatomic, strong) NSString *topic;

///用户举报（用于举报，屏蔽此人的请求）
@property (nonatomic, strong) NSString *uid;

///是否是自己的帖子（用于删除和举报帖子）
@property (nonatomic, strong) NSNumber *is_self;

///帖子点赞数
@property (nonatomic, strong) NSNumber *praise_count;

///帖子评论数
@property (nonatomic, strong) NSNumber *comment_count;

///是否关注圈子
@property (nonatomic, strong) NSNumber *is_follow_topic;

///是否点赞帖子
@property (nonatomic, strong) NSNumber *is_praised;

///用户身份牌的小图URL
@property (nonatomic, strong) NSString *identity_pic;

- (instancetype)initWithDic:(NSDictionary *)dict;



@end

NS_ASSUME_NONNULL_END
