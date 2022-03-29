//
//  DiscoverAD.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
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
