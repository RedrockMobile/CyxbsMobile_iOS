//
//  CYSearchEndKnowledgeDetailModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CYSearchEndKnowledgeDetailModel.h"

@implementation CYSearchEndKnowledgeDetailModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.titleStr = dic[@"title"];
        self.contentStr = dic[@"description"];
        self.sourceStr = dic[@"from"];
        if (![dic[@"photo_url"] isEqualToString:@""]) {
            self.image = dic[@"photo_url"];
        }
    }
    return self;
}
+ (instancetype)initWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDic:dict];
}
@end
