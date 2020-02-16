//
//  MineQAMyQuestionDraftItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAMyQuestionDraftItem.h"

/**
{
    "draft_question_id": 26,
    "title": "",
    "description": "",
    "latest_edit_time": "2020-02-15 21:02:50"
}
*/

@implementation MineQAMyQuestionDraftItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.questionDraftID = [NSString stringWithFormat:@"%@", dict[@"draft_question_id"]];
        self.title = dict[@"title"];
        self.questionDraftContent = dict[@"description"];
        self.lastEditTime = dict[@"latest_edit_time"];
    }
    return self;
}

@end
