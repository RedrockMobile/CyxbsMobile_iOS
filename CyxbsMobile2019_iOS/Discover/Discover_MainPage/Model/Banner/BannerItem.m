//
//  BannerItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "BannerItem.h"

@implementation BannerItem
- (instancetype)initWithdictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.picureID = dict[@"id"];
        self.pictureUrl = dict[@"picture_url"];
        self.pictureGoToUrl = dict[@"picture_goto_url"];
        self.keyword = dict[@"keyword"];
    }
    return self;
}
@end
