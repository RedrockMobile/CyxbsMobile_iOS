//
//  PostItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostItem.h"

@implementation PostItem

- (instancetype)initWithDic:(NSDictionary *)dict {
    if ([super init]) {
        self.post_id = dict[@"post_id"];
        self.avatar = dict[@"avatar"];
        self.nick_name = dict[@"nickname"];
        self.publish_time = dict[@"publish_time"];
        self.content = dict[@"content"];
        self.pics = dict[@"pics"];
        self.topic = dict[@"topic"];
        self.uid = dict[@"uid"];
        self.is_self = dict[@"is_self"];
        self.praise_count = [NSNumber numberWithInt:[dict[@"praise_count"] intValue]];
        self.comment_count = [NSNumber numberWithInt:[dict[@"comment_count"] intValue]];
        self.is_follow_topic = dict[@"is_follow_topic"];
        self.is_praised = dict[@"is_praised"];
        self.identity_pic = dict[@"identity_pic"];
    }
    return self;
}

@end
