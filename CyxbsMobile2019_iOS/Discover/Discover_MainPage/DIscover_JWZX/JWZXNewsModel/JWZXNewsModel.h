//
//  JWZXNewsModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**JWZXNewsModel
 * 教务在线新闻模型
 */

#import <Foundation/Foundation.h>

#import "JWZXNewsInformation.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXNewsModel

@interface JWZXNewsModel : NSObject

/// 教务在线信息
@property (nonatomic, strong) JWZXNewsInformation *jwzxNews;

/// 网络请求教务在线信息
- (void)requestJWZXPage:(NSUInteger)page
                success:(void (^)(void))setJWZX
                failure:(void (^) (NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
