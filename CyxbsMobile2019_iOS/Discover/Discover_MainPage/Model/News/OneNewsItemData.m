//
//  OneNewsItemData.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "OneNewsItemData.h"

@implementation OneNewsItemData
- (instancetype)initWithDict:(NSDictionary *)dic {
    if(self = [super init]) {
        self.NewsID = dic[@"id"];
        self.title = dic[@"title"];
        self.date = dic[@"date"];
        self.readCount = dic[@"readCount"];
    }
    return self;
}
@end
