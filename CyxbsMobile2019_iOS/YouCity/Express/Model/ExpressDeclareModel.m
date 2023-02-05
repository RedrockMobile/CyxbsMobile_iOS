//
//  ExpressDeclareModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressDeclareModel.h"

@implementation ExpressDeclareModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.declareId = dic[@"id"];
    }
    return self;
}

@end
