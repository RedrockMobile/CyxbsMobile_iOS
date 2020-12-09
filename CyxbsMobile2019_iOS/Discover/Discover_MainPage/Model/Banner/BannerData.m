//
//  BannerData.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "BannerData.h"

@implementation BannerData
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.status = dict[@"status"];
        self.info = dict[@"info"];
        NSMutableArray<BannerItem*>*arr = [NSMutableArray array];
        for(NSDictionary *d in dict[@"data"]) {
            BannerItem * b = [[BannerItem alloc]initWithdictionary:d];
            [arr addObject:b];
        }
        self.bannerItems = arr;
    }
    return self;
}
@end
