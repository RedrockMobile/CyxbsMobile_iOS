//
//  EmptyClassModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "EmptyClassModel.h"

@implementation EmptyClassModel
- (instancetype) initWithDict: (NSDictionary *)dict {
    if(self = [super init]) {
        self.emptyClassArray = dict[@"nowWeek"];
        self.info = dict[@"200"];
        self.info = dict[@"info"];
        self.emptyClassArray = dict[@"data"];
    }
    return self;
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc]initWithDict:dictionary];
}
@end
