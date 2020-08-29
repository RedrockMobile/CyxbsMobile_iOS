//
//  TermGrades.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TermGrades.h"

@implementation TermGrades
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.a_credit = dict[@"a_credit"];
        self.b_credit = dict[@"b_credit"];
        NSMutableArray<TermGrade*> *arr = [NSMutableArray array];
        for (NSDictionary * d in dict[@"term_grades"]) {
            TermGrade * g = [[TermGrade alloc]initWithDictionary:d];
            [arr addObject:g];
        }
        self.termGrades = arr;
    }
    return self;
}
@end
