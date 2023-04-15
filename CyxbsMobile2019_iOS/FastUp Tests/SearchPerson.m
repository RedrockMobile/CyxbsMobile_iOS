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

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        SearchPerson *item = (SearchPerson *)other;
        return [self.stunum isEqualToString:item.stunum]
        && [self.name isEqualToString:item.name]
        && [self.gender isEqualToString:item.gender]
        && [self.classnum isEqualToString:item.classnum]
        && [self.major isEqualToString:item.major]
        && [self.grade isEqualToString:item.grade];
    }
}

- (NSUInteger)hash {
    return self.stunum.hash;
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.stunum forKey:@"stunum"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.classnum forKey:@"classnum"];
    [coder encodeObject:self.major forKey:@"major"];
    [coder encodeObject:self.grade forKey:@"grade"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.stunum = [coder decodeObjectForKey:@"stunum"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.classnum = [coder decodeObjectForKey:@"classnum"];
        self.major = [coder decodeObjectForKey:@"major"];
        self.grade = [coder decodeObjectForKey:@"grade"];
    }
    return self;
}

@end
