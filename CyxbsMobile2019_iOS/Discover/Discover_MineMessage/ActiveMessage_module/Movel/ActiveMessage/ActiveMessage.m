//
//  ActiveMessage.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ActiveMessage.h"

@implementation ActiveMessage

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.content = dic[@"content"];
        self.userHeadURL = dic[@"user_head_url"];
        self.author = dic[@"user_name"];
        self.msgID = [dic[@"id"] longValue];
        self.date = [[NSDate dateString:[dic[@"date"] substringToIndex:10] fromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"yyyy-MM-dd"] stringFromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"yyyy-M-d"];
        self.imgURL = dic[@"pic_url"];
        self.url = dic[@"redirect_url"];
        self.hadRead = [dic[@"has_read"] boolValue];
    }
    return self;
}

@end
