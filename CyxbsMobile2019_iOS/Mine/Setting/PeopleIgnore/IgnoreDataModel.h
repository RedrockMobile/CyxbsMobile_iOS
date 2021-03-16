//
//  IgnoreDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 解析屏蔽的人的数据的model
@interface IgnoreDataModel : NSObject

/// 头像URL
@property(nonatomic,copy)NSString *avatar;

/// 个性签名
@property(nonatomic,copy)NSString *introduction;

/// 昵称
@property(nonatomic,copy)NSString *nickName;

/// 用户唯一标识码
@property(nonatomic,copy)NSString *uid;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
