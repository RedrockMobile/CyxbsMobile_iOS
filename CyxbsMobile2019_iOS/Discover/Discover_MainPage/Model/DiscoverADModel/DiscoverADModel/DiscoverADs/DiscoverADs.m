//
//  DiscoverADs.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DiscoverADs.h"

#pragma mark - DiscoverADs

@implementation DiscoverADs

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.status = dict[@"status"];
        self.info = dict[@"info"];
        NSMutableArray <DiscoverAD *> *ads = [NSMutableArray array];
        for(NSDictionary *dic in dict[@"data"]) {
            DiscoverAD *AD = [[DiscoverAD alloc] initWithDictionary:dic];
            [ads addObject:AD];
        }
        self.ADs = [ads copy];
    }
    return self;
}

@end
