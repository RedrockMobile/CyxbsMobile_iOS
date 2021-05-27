//
//  ActivityItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ActivityItem.h"

@implementation ActivityItem

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.idNum = dic[@"id"];
        self.name = dic[@"name"];
        self.descript = dic[@"description"];
        self.sign_up_start = dic[@"sign_up_start"];
        self.sign_up_last = dic[@"sign_up_last"];
        self.last_date = dic[@"last_date"];
        self.hour = dic[@"hour"];
        self.place = dic[@"place"];
    }
    return self;
}

// 你可以通过在家族里养一只狗来给你的孩子上一节重要的课程，关于关于负责任和照顾另一种生命
@end
