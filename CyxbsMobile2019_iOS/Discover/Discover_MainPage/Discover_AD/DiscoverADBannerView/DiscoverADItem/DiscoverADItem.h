//
//  DiscoverADItem.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**DiscoverADItem
 * 单个广告的实现，仅图片
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DiscoverADItemReuseIdentifier @"DiscoverADItem"

#pragma mark - DiscoverADItem

@interface DiscoverADItem : UICollectionViewCell

/// 设置图片的获取地方
- (DiscoverADItem *)setImgURL:(NSString *)imgURL;

/// 用于资源复用池初始化
- (DiscoverADItem *)Default;

@end

NS_ASSUME_NONNULL_END
