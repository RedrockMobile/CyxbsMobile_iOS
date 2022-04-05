//
//  JWZXNew.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**JWZXNew
 * 教务在线单个新闻
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXNew

@interface JWZXNew : NSObject

/// 新闻的id
@property (nonatomic, copy)NSString *NewsID;

/// 新闻的标题
@property (nonatomic, copy)NSString *title;

/// 日期
@property (nonatomic, copy)NSString *date;

/// 阅读数
@property (nonatomic, copy)NSString *readCount;

/// 根据字典得到
- (instancetype)initWithDictionary: (NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
