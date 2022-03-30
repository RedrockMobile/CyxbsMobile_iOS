//
//  DiscoverAD.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverAD.h"

#pragma mark - DiscoverAD

@implementation DiscoverAD

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.picureID = dict[@"id"];
        self.pictureUrl = dict[@"picture_url"];
        self.pictureGoToUrl = dict[@"picture_goto_url"];
        self.keyword = dict[@"keyword"];
    }
    return self;
}
@end
