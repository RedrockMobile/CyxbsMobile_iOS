//
//  JWZXNewsAnnexModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNewsAnnexModel.h"

@implementation JWZXNewsAnnexModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.annexID = dic[@"id"];
    }
    return self;
}

@end
