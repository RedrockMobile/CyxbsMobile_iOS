//
//  UserItemTool.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/24.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserItemTool : NSObject

/// 获取UserItem单例对象
+ (UserItem *)defaultItem;

/// 获取缓存路径
+ (NSString *)userItemPath;

/// 归档对象
+ (void)archive:(UserItem *)item;


/// 退出登录
+ (void)logout;

/// 刷新Token
+ (void)refresh;

@end

NS_ASSUME_NONNULL_END
