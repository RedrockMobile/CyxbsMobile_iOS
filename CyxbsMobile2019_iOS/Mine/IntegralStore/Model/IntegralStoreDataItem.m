//
//  IntegralStoreDataItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreDataItem.h"

@implementation IntegralStoreDataItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.value = dict[@"value"];
        self.num = dict[@"num"];
        self.photo_src = dict[@"photo_src"];
        self.isVirtual = dict[@"isVirtual"];
    }
    return self;
}

@end
