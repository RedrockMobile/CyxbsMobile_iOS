//
//  ExpressPickPutModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickPutModel.h"

@implementation ExpressPickPutModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.putStatistic = dic[@"statistic"]; // 字典 { string: number }
        self.putVoted = dic[@"voted"];
    }
    return self;
}

@end
