//
//  questionItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "questionItem.h"

@implementation questionItem

//- (instancetype)initWithDict:(NSDictionary *)dict {
//    if ([super init]) {
//        self.questionId = dict[@"id"];
//        self.questionContent = dict[@"content"];
//    }
//    return self;
//}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([super init]) {
        self.day = dict[@"day"];
        self.teacher = dict[@"teacher"];
    }
    return self;
}

@end
