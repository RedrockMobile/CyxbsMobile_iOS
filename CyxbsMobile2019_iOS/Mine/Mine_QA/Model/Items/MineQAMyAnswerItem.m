//
//  MineQAMyAnswerItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAMyAnswerItem.h"

//{
//    "question_id": 1247,
//    "integral": 2,
//    "answer_id": 1607,
//    "answer_content": "test",
//    "answer_time": "2020-02-15 21:07:14",
//    "type": "未采纳"
//}

@implementation MineQAMyAnswerItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.questionID = dict[@"question_id"];
        self.integral = [NSString stringWithFormat:@"%@", dict[@"integral"]];
        self.answerID = [NSString stringWithFormat:@"%@", dict[@"answer_id"]];
        self.answerContent = dict[@"answer_content"];
        self.answerTime = dict[@"answer_time"];
        self.type = dict[@"type"];
    }
    return self;
}

@end
