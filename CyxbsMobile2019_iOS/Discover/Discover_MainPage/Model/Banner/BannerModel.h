//
//  BannerModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerData.h"
NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject
@property (nonatomic)BannerData *bannerData;
-(void)fetchData;
@end

NS_ASSUME_NONNULL_END
