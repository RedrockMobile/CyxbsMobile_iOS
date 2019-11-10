//
//  UserItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserItem : NSObject<NSCoding>

/// Token
@property (nonatomic, copy) NSString *token;

/// 该token什么时候颁发（Unix时间戳）
@property (nonatomic, copy) NSString *iat;

/// 该token什么时候过期（Unix时间戳）
@property (nonatomic, copy) NSString *exp;

/// 用来刷新token的凭证，有效时间45天，只可以使用一次
@property (nonatomic, copy) NSString *refreshToken;

/// 真实姓名
@property (nonatomic, copy) NSString *realName;

/// 性别
@property (nonatomic, copy) NSString *gender;

/// 用户的唯一识别码
@property (nonatomic, copy) NSString *redid;

/// 学号
@property (nonatomic, copy) NSString *stuNum;

/// 昵称
@property (nonatomic, copy) NSString *nickname;

/// 个人介绍
@property (nonatomic, copy) NSString *introduction;

/// 头像URL
@property (nonatomic, copy) NSString *headImgUrl;

/// 手机号
@property (nonatomic, copy) NSString *phone;

/// QQ号
@property (nonatomic, copy) NSString *qq;

/// 已连续签到天数
@property (nonatomic, copy) NSString *checkInDay;

/// 积分
@property (nonatomic, copy) NSString *integral;

/// 楼栋：例如26
@property (nonatomic, copy) NSString *building;

/// 房间号：例如413
@property (nonatomic, copy) NSString *room;

/// 获得单例对象
+ (UserItem *)defaultItem;

@end

NS_ASSUME_NONNULL_END
