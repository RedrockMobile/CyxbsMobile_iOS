//
//  RemarkParseModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemarkParseModel.h"

@implementation RemarkParseModel
- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        NSDictionary *commentDict = dict[@"comment"];
        //头像
        self.avatar = commentDict[@"avatar"];
        self.comment_id = commentDict[@"comment_id"];
        //评论内容
        self.content = commentDict[@"content"];
        //被评论人的名字，如果是评论的评论，那么是@""
        self.from_nickname = commentDict[@"from_nickname"];
        
        self.has_more_reply = commentDict[@"has_more_reply"];
        
        //是否赞过了
        self.is_praised = commentDict[@"is_praised"];
        self.is_self = commentDict[@"is_self"];
        //别人的昵称
        self.nick_name = commentDict[@"nick_name"];
        //被回复的内容
        self.from = dict[@"from"];
        
        self.publish_time = commentDict[@"publish_time"];
//        self.<#hhhhh#> = commentDict[@"<#hhhhh#>"];
    }
    return self;
}
@end
