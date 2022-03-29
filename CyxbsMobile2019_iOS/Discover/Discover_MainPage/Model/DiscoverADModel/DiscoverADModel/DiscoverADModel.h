//
//  DiscoverADModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DiscoverADs.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DiscoverADModel

@interface DiscoverADModel : NSObject

/// 所有广告位持有
@property (nonatomic, strong)DiscoverADs *discoverADs;

/// 网络请求
- (void)GETADsSuccess:(void (^)(DiscoverADModel *ADModel))setModel;

@end

NS_ASSUME_NONNULL_END
