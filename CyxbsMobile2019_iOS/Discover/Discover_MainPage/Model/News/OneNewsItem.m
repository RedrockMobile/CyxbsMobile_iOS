//
//  OneNewsItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/10.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "OneNewsItem.h"

@implementation OneNewsItem
-(instancetype)initWithDict: (NSDictionary *)dict {
    if (self = [super init]) {
        self.page = dict[@"page"];
        self.status = dict[@"status"];
        self.info = dict[@"info"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            OneNewsItemData *data = [[OneNewsItemData alloc]initWithDict:dic];
            [dataArray addObject:data];
        }
        self.dataArray = dataArray;
    }
    return self;
    
}
@end
