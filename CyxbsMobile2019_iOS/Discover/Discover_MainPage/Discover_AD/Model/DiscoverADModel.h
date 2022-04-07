//
//  DiscoverADModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**模型，用于获取数据
 * 以及MVP的逻辑处理能力
 * 包括网络请求
 */

#import <UIKit/UIKit.h>

#import "DiscoverADs.h"

NS_ASSUME_NONNULL_BEGIN

@class DiscoverADModel;

#pragma mark - DiscoverADModelDelegate

@protocol DiscoverADModelDelegate <NSObject>

@required

/// 回传得到cell
- (__kindof UICollectionViewCell *)discoverAD:(DiscoverAD * _Nullable)AD cellForCollectionView:(UICollectionView *)collectionView;

@end

#pragma mark - DiscoverADModel

/**DiscoverADModel
 * 图片轮播的逻辑控制Model
 * 数据在ADCollectionInformation里面
 */

@interface DiscoverADModel : NSObject <
    UICollectionViewDataSource
>

/// 所有广告位持有
@property (nonatomic, strong) DiscoverADs *ADCollectionInformation;

/// 代理
@property (nonatomic, weak) id <DiscoverADModelDelegate> delegate;

/// 网络请求
- (void)requestBannerSuccess:(void (^)(void))setModel
                     failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
