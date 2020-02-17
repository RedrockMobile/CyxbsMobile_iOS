//
//  MineQARecommentItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQARecommentItem.h"

/**
{
    "question_id": 1247,
    "answer_id": 1607,
    "comment_content": "测试",
    "commenter_nickname": "王一成",
    "commenter_imageurl": "https://cyxbsmobile.redrock.team/cyxbsMobile/Public/photo/1569871625_510574370.png"
},
*/

@implementation MineQARecommentItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.questionID = [NSString stringWithFormat:@"%@", dict[@"question_id"]];
        self.answerID = [NSString stringWithFormat:@"%@", dict[@"answer_id"]];
        self.commentContent = dict[@"comment_content"];
        self.commenterNicname = dict[@"commenter_nickname"];
        self.commenterImageURL = dict[@"commenter_imageurl"];
    }
    return self;
}

@end
