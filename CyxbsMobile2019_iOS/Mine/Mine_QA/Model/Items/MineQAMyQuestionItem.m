//
//  MineQAMyQuestionItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAMyQuestionItem.h"

@implementation MineQAMyQuestionItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.questionID = [NSString stringWithFormat:@"%@", dict[@"question_id"]];
        self.title = dict[@"title"];
        self.questionContent = dict[@"description"];
        self.integral = dict[@"integral"];
        self.type = dict[@"type"];
        self.disappearTime = dict[@"disappear_at"];
    }
    return self;
}

@end
