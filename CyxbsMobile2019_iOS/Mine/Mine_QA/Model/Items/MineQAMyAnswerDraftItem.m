//
//  MineQAMyAnswerDraftItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAMyAnswerDraftItem.h"

/**
"data": [
    {
        "draft_answer_id": 26,
        "question_id": 0,
        "latest_edit_time": "2020-02-15 21:02:50",
        "draft_answer_content": "test"
    }
]
*/

@implementation MineQAMyAnswerDraftItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.answerDraftID = [NSString stringWithFormat:@"%@", dict[@"draft_answer_id"]];
        self.questionID = [NSString stringWithFormat:@"%@", dict[@"question_id"]];
        self.lastEditTime = dict[@"latest_edit_time"];
        self.answerDraftContent = dict[@"draft_answer_content"];
    }
    return self;
}

@end
