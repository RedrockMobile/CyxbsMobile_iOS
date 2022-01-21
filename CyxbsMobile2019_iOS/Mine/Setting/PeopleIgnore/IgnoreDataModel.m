//
//  IgnoreDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/3.
//  Copyright © 2021 Redrock. All rights reserved.
//  解析屏蔽的人的数据的model

#import "IgnoreDataModel.h"

@implementation IgnoreDataModel
- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        self.avatar = dict[@"avatar"];
        self.introduction = dict[@"introduction"];
        self.nickName = dict[@"nickName"];
        self.uid = dict[@"uid"];
    }
    return self;
}
@end
