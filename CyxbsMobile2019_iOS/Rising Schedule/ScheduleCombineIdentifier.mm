//
//  ScheduleCombineIdentifier.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineIdentifier.h"

#import "ScheduleCombineIdentifier+WCTTableCoding.h"

@implementation ScheduleCombineIdentifier

WCDB_IMPLEMENTATION(ScheduleCombineIdentifier)

WCDB_SYNTHESIZE(ScheduleCombineIdentifier, sno)
WCDB_SYNTHESIZE(ScheduleCombineIdentifier, type)
WCDB_SYNTHESIZE(ScheduleCombineIdentifier, iat)

- (instancetype)initWithName:(NSString *)name type:(ScheduleModelRequestType)type {
    self = [super init];
    if (self) {
        _sno = name.copy;
        _type = type;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleCombineIdentifier *obj = [[ScheduleCombineIdentifier alloc] initWithName:self.sno type:self.type];
    obj.iat = self.iat;
    return obj;
}

- (NSUInteger)hash {
    return self.key.hash;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:ScheduleCombineIdentifier.class]) {
        ScheduleCombineIdentifier *obj = (ScheduleCombineIdentifier *)object;
        return [self.sno isEqualToString:obj.sno] && self.type == obj.type;
    }
    return NO;
}

- (NSString *)key {
    return [_type stringByAppendingString:_sno].copy;
}

@end
