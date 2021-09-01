//
//  UserItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DEPRECATED_MSG_ATTRIBUTE("\n不要使用UserItem来获取你需要的信息，使用UserDefaultTool")
@interface UserItem : NSObject<NSCoding> 
//MARK: - 个人信息/登录相关的
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

/// 所属学院
@property (nonatomic, copy) NSString *college;

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



//MARK: - 积分商城相关
/// 已连续签到天数
@property (nonatomic, copy) NSString *checkInDay;

/// 积分
@property (nonatomic, copy) NSString *integral;

/// 签到排名
@property (nonatomic, copy) NSString *rank;

/// 签到排名（百分比）
@property (nonatomic, copy) NSString *rank_Persent;

/// 一周内的签到情况
@property (nonatomic, copy) NSString *week_info;

/// 是否能签到
@property (nonatomic, assign) BOOL canCheckIn;



//MARK: - 电费相关（可能）
/// 楼栋：例如26
@property (nonatomic, copy) NSString *building;

/// 房间号：例如413
@property (nonatomic, copy) NSString *room;



//MARK: - 志愿服务相关
/// 志愿服务账号
@property (nonatomic, copy) NSString *volunteerUserName;

/// 志愿服务密码
@property (nonatomic, copy) NSString *volunteerPassword ;


///第一次登陆（是邮问那边需要的一个标记位）
@property (nonatomic, assign) BOOL firstLogin;

/// ids绑定成功（查询成绩/考试安排那边需要的）
@property (nonatomic, assign) BOOL idsBindingSuccess;


/// 获得单例对象
+ (UserItem *)defaultItem;

- (void)getUserInfo;

@end

NS_ASSUME_NONNULL_END
