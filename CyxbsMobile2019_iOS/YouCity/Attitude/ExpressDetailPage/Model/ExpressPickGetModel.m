//
//  ExpressPickGetModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ExpressPickGetModel.h"

@implementation ExpressPickGetModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.getId = dic[@"id"];
        self.choices = dic[@"choices"];
        self.getStatistic = dic[@"statistic"]; // 也是字典 { string: number }
//        self.statisticStr =
        self.title = dic[@"title"];
        self.choices = dic[@"choices"];
    }
    return self;
}

@end
