//
//  TermGrade.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TermGrade.h"
@implementation TermGrade
- (instancetype)initWithDictionary: (NSDictionary *)dict {
    if (self = [super init]) {
        self.term = dict[@"term"];
        self.gpa = dict[@"gpa"];
        self.grade = dict[@"grade"];
        self.rank = dict[@"rank"];
        NSMutableArray<SingleGrade*> *arr = [NSMutableArray array];
        for (NSDictionary *g in dict[@"singe_grades"]) {
            SingleGrade *single = [[SingleGrade alloc]initWithDictionary:g];
            [arr addObject:single];
        }
        self.singegradesArr = arr;
    }
    return self;
}
@end
