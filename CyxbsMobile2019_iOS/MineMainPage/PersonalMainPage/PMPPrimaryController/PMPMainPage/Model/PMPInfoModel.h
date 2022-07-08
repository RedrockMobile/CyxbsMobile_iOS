//
//  PMPInfoModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 个人信息
 * 根据 redid 区分
 */
@interface PMPInfoModel : NSObject

/// 背景图片
@property (nonatomic, copy) NSString * background_url;
/// 生日
@property (nonatomic, copy) NSString * birthday;
/// 学院
@property (nonatomic, copy) NSString * college;
/// 星座
@property (nonatomic, copy) NSString * constellation;
/// 性别
@property (nonatomic, copy) NSString * gender;
///年级
@property (nonatomic, copy) NSString * grade;
/// 个性身份
@property (nonatomic, copy) NSArray <NSString *> * identityies;
/// 个性签名
@property (nonatomic, copy) NSString * introduction;
/// 是不是自己
@property (nonatomic, assign) BOOL isSelf;
/// 昵称
@property (nonatomic, copy) NSString * nickname;
/// 手机号
@property (nonatomic, copy) NSString * phone;
/// 头像
@property (nonatomic, copy) NSString * photo_src;
/// 头像缩略图
@property (nonatomic, copy) NSString * photo_thumbnail_src;
/// 
@property (nonatomic, assign) BOOL isBefocused;
/// 是否被关注?
@property (nonatomic, assign) BOOL isFocus;
/// qq
@property (nonatomic, copy) NSString * qq;
/// redid
@property (nonatomic, copy) NSString * redid;
/// stunum
@property (nonatomic, copy) NSString * stunum;
/// uid
@property (nonatomic, assign) NSInteger uid;

/// 得到自己的数据
+ (void)getDataWithRedid:redid
                 Success:(void (^)(PMPInfoModel * infoModel))success
                 failure:(void (^)(void))failure;

/// 更新背景图片
+ (void)uploadbackgroundImage:(UIImage *)backgroundImage
                      success:(void (^)(NSDictionary * _Nonnull))success
                      failure:(void (^)(NSError * _Nonnull))failure;

/// 关注/取关
+ (void)focusWithRedid:(NSString *)redid
               success:(nonnull void (^)(BOOL))success
               failure:(nonnull void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
