//
//  SystemMessage.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SystemMessage.h"

#pragma mark - SystemMessage

@implementation SystemMessage

#pragma mark - Life cycle

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.content = dic[@"content"];
        self.msgID = [dic[@"id"] longValue];
        self.url = dic[@"redirect_url"];
        self.date = [[NSDate dateString:[dic[@"date"] substringToIndex:10] fromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"yyyy-MM-dd"] stringFromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"yyyy-M-d"];
        self.hadRead = [dic[@"has_read"] boolValue];
    }
    return self;
}

@end
