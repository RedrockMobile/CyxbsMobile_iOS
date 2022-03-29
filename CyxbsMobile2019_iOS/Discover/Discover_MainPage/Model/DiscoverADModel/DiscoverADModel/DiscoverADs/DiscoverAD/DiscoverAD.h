//
//  DiscoverAD.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

/**DiscoverAD
 * “发现” 广告内容
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DiscoverAD

@interface DiscoverAD : NSObject

/// 图片ID
@property (nonatomic, copy)NSString *picureID;

/// 获取图片的URL
@property (nonatomic, copy)NSString *pictureUrl;

/// 单击图片后应去的URL
@property (nonatomic, copy)NSString *pictureGoToUrl;

/// 图片的简介信息
@property (nonatomic, copy)NSString *keyword;

/// 根据字典得到一个广告Item
- (instancetype) initWithDictionary: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
