//
//  PraiseParseModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 解析点赞页的网络请求数据
@interface PraiseParseModel : NSObject
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *nick_name;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *type;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
