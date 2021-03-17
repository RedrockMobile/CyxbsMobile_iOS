//
//  RemarkParseModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//  解析评论页的数据的模型

#import "RemarkParseModel.h"

@implementation RemarkParseModel
- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        NSDictionary *commentDict = dict[@"comment"];
        //头像
        self.avatar = commentDict[@"avatar"];
        self.comment_id = [NSString stringWithFormat:@"%@",commentDict[@"comment_id"]];
        //评论内容
        self.content = commentDict[@"content"];
        //被评论人的名字
        self.from_nickname = commentDict[@"from_nickname"];
        
        self.has_more_reply = [NSString stringWithFormat:@"%@",commentDict[@"has_more_reply"]];
        
        //是否赞过了
        self.is_praised = [NSString stringWithFormat:@"%@",commentDict[@"is_praised"]];
        self.is_self = [NSString stringWithFormat:@"%@",commentDict[@"is_self"]];
        //别人的昵称
        self.nick_name = commentDict[@"nick_name"];
        
        self.pics = commentDict[@"pics"];
        
        self.post_id = [NSString stringWithFormat:@"%@",commentDict[@"post_id"]];
        self.praise_count = [NSString stringWithFormat:@"%@",commentDict[@"praise_count"]];
        self.publish_time = [NSString stringWithFormat:@"%@",commentDict[@"publish_time"]];
        self.reply_id = [NSString stringWithFormat:@"%@",commentDict[@"reply_id"]];
        
        self.reply_list = commentDict[@"reply_list"];
        self.uid = commentDict[@"uid"];
        
        //被回复的内容
        self.from = dict[@"from"];
        //type 为@"1"为动态被评论，为@"2"为评论被评论
        self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
//        self.<#hhhhh#> = commentDict[@"<#hhhhh#>"];
    }
    return self;
}
@end
