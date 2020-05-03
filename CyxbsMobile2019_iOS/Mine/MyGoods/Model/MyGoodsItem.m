//
//  MyGoodsItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/3.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsItem.h"

@implementation MyGoodsItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.photo_src = dict[@"photo_src"];
        self.time = dict[@"time"];
        self.value = [dict[@"value"] stringValue];
    }
    return self;
}

@end
