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
       self.termGrades = dict[@"term_grades"];
       self.credits = dict[@"credits"];
    }
    return self;
}
@end
