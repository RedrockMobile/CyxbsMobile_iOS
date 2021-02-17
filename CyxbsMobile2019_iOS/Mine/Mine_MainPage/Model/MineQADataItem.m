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
        
        self.askNum = [dict[@"data"][@"ask_posted_number"] stringValue];
        self.answerNum = [dict[@"data"][@"answer_posted_number"] stringValue];
        self.commentNum = [dict[@"data"][@"comment_number"] stringValue];
        self.praiseNum = [dict[@"data"][@"praise_number"] stringValue];
    }
    return self;
}


//MARK: - 重写了这几个属性的get方法，因为它们实际上是NSNumber类型......无语😓
//不这样改的后果是:赋值给label.text时会崩溃
- (NSString *)askNum{
    return [NSString stringWithFormat:@"%@",_askNum];
}

- (NSString *)answerNum{
    return [NSString stringWithFormat:@"%@",_answerNum];
}

- (NSString *)commentNum{
    return [NSString stringWithFormat:@"%@",_commentNum];
}
- (NSString *)praiseNum{
    return [NSString stringWithFormat:@"%@",_praiseNum];
}
@end
