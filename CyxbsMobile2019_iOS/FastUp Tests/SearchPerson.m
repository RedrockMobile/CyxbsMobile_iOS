//
//  SearchPerson.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPerson.h"

@implementation SearchPerson

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _stunum = dic[@"stunum"];
        _name = dic[@"name"];
        _gender = dic[@"gender"];
        _classnum = dic[@"classnum"];
        _major = dic[@"major"];
        _grade = dic[@"grade"];
    }
    return self;
}

@end
