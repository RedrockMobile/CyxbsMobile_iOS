//
//  DiscoverADBannerView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**DiscoverADBannerView
 * 广告位无限轮播
 */

#import <UIKit/UIKit.h>

#import "DiscoverAdItem.h"

NS_ASSUME_NONNULL_BEGIN

@class DiscoverADBannerView;

#pragma mark - DiscoverADBannerViewDelegate

@protocol DiscoverADBannerViewDelegate <NSObject>

@required

/// 单击了哪个item（以防无限轮播的思路，这里会返回实际所在item下标）
- (void)discoverADBannerView:(DiscoverADBannerView *)bannerView didSelectedAtItem:(NSUInteger)item;

@optional

/// 开始滑动（不管是不是手动，自动轮播时，animate为0则不掉用）
- (void)discoverADBannerViewBeginScroll:(DiscoverADBannerView *)bannerView;

/// 正在滑动
- (void)discoverADBannerViewDidScroll:(DiscoverADBannerView *)bannerView;

/// 完整结束滑动
- (void)discoverADBannerViewEndScroll:(DiscoverADBannerView *)bannerView;

@end

#pragma mark - DiscoverADBannerView

@interface DiscoverADBannerView : UICollectionView <
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
>

/// 时间
@property (nonatomic) NSTimeInterval autoTimeInterval;

/// 广告的个数，会产生ADsCount + 2个广告
@property (nonatomic) NSUInteger ADsCount;

/// 代理
@property (nonatomic, weak) id <DiscoverADBannerViewDelegate> ssr_delegate;

/// 得到DiscoverADItem
- (DiscoverADItem *)getReusableDiscoverADItem;

/// 计算当前所在页
- (NSUInteger)currentPage;

@end

NS_ASSUME_NONNULL_END
