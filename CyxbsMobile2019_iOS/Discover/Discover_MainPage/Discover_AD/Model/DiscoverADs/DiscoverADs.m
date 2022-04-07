//
//  DiscoverADs.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADs.h"

#pragma mark - DiscoverADs

@implementation DiscoverADs

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.status = dict[@"status"];
        self.netMessage = dict[@"info"];
        NSMutableArray <DiscoverAD *> *ads = [NSMutableArray array];
        for(NSDictionary *dic in dict[@"data"]) {
            DiscoverAD *AD = [[DiscoverAD alloc] initWithDictionary:dic];
            [ads addObject:AD];
        }
        self.ADCollection = [ads copy];
    }
    return self;
}

@end
