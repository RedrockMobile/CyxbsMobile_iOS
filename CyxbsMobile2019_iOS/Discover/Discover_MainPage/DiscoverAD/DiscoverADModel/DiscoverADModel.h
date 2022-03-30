//
//  DiscoverADModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

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

@interface DiscoverADModel : NSObject <
    UICollectionViewDataSource
>

/// 所有广告位持有
@property (nonatomic, strong) DiscoverADs *discoverADs;

/// 代理
@property (nonatomic, weak) id <DiscoverADModelDelegate> delegate;

/// 网络请求
- (void)GETADsSuccess:(void (^)(void))setModel;

@end

NS_ASSUME_NONNULL_END
