//
//  ExpressPickGetItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickGetItem.h"

@implementation ExpressPickGetItem
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.getId = dic[@"id"];
        self.choices = dic[@"choices"];
        self.getStatistic = dic[@"statistic"]; // 也是字典 { string: number }
        self.title = dic[@"title"];
        self.choices = dic[@"choices"];
    }
    return self;
}
@end
