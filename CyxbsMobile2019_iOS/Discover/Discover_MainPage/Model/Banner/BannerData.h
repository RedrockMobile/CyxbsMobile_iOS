//
//  BannerData.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface BannerData : NSObject
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString * info;
@property (nonatomic)NSArray<BannerItem*>* bannerItems;
- (instancetype) initWithDictionary: (NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
