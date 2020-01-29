//
//  MineQADataItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQADataItem.h"

@implementation MineQADataItem

MJExtensionCodingImplementation

+ (NSString *)archivePath {
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"MineQADataItem.data"];
}

- (void)archiveItem {
    [NSKeyedArchiver archiveRootObject:self toFile:[MineQADataItem archivePath]];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.askNum = dict[@"ask_posted_number"];
        self.answerNum = dict[@"answer_posted_number"];
        self.commentNum = dict[@"commnet_number"];
        self.praiseNum = dict[@"praise_number"];
    }
    return self;
}

@end
