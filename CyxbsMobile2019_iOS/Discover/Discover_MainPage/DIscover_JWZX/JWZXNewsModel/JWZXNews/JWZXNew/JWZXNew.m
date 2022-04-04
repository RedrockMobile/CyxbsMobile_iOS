//
//  JWZXNew.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNew.h"

#pragma mark - JWZXNew

@implementation JWZXNew

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if(self) {
        self.NewsID = dic[@"id"];
        self.title = dic[@"title"];
        self.date = dic[@"date"];
        self.readCount = dic[@"readCount"];
    }
    return self;
}

@end
