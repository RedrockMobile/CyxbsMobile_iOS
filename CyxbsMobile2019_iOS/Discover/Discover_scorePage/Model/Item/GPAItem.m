//
//  GPAItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GPAItem.h"
@implementation GPAItem



- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
       self.status = dict[@"status"];
        self.termGrades = [[TermGrades alloc]initWithDictionary:dict[@"data"]];
//       self.termGrades = dict[@"term_grades"];
    }
    return self;
}
@end
