//
//  DynamicDetailViewModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 动态详情页的动态详情的view的model，和新版邮问主页文件夹的PostItem大同小异，但进行了一些优化，主页的推荐Table的cell也可采用这个模型
 利用KVC进行字典转模型的辅助 API：setValueForKeyWithDictionary:
 注：1.模型中的属性名和字典中的key必须一样，不然会出错
    2.在.m文件重写 setValue:forUndefinedKey:方法，防止找不到值而崩溃
 */
@interface DynamicDetailViewModel : NSObject
///帖子唯一id
@property (nonatomic, copy) NSString *post_id;

///头像
@property (nonatomic, copy) NSString *avatar;

///昵称
@property (nonatomic, copy) NSString *nickname;

///时间戳
@property (nonatomic, strong) NSNumber *publish_time;

///帖子内容
@property (nonatomic, copy) NSString *content;

///图片数组
@property (nonatomic, copy) NSArray *pics;

///圈子名
@property (nonatomic, copy) NSString *topic;

///用户举报（用于举报，屏蔽此人的请求）
@property (nonatomic, copy) NSString *uid;

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

@property (nonatomic, assign) CGFloat cellHeight;

/// 获取这个model请求得来的数据的高度
- (CGFloat)getModelHeight;
@end

NS_ASSUME_NONNULL_END
