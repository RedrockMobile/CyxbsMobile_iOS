//
//  JWZXNewsInformation.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNewsInformation.h"

#pragma mark - JWZXNews

@implementation JWZXNewsInformation

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.page = [dict[@"page"] longValue];
        self.status = dict[@"status"];
        self.netMessage = dict[@"info"];
        NSMutableArray *newsMA = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            JWZXNew *aNew = [[JWZXNew alloc] initWithDictionary:dic];
            [newsMA addObject:aNew];
        }
        self.news = [newsMA copy];
    }
    return self;
}

@end
