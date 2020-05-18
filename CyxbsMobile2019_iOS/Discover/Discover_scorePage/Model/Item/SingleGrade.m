//
//  SingleGrade.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SingleGrade.h"

@implementation SingleGrade
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init] ){
        self.class_num = dict[@"class_num"];
        self.class_name = dict[@"class_name"];
        self.class_type = dict[@"class_type"];
        self.credit = dict[@"credit"];
        self.exam_type = dict[@"exam_type"];
        self.grade = dict[@"grade"];
        self.gpa = dict[@"gpa"];
    }
    return self;
}
@end
