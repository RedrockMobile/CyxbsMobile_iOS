//
//  MineQACommentItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQACommentItem.h"

@implementation MineQACommentItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.questionID = [NSString stringWithFormat:@"%@", dict[@"question_id"]];
        self.answerID = [NSString stringWithFormat:@"%@", dict[@"answer_id"]];
        self.commentContent = dict[@"comment_content"];
        self.answerer = dict[@"answerer"];
    }
    return self;
}

@end
