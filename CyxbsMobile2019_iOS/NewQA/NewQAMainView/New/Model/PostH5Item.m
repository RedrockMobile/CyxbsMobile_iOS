//
//  PostH5Item.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/10/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PostH5Item.h"

@implementation PostH5Item

- (instancetype)initWithDic:(NSDictionary *)dict {
    if ([super init]) {
        self.avatar = dict[@"avatar"];
        self.nick_name = dict[@"nick_name"];
        self.pic = dict[@"pic"];
        self.annotation = dict[@"annotation"];
        self.link_url = dict[@"link_url"];
    }
    return self;
}

@end
