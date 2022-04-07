//
//  SchoolBusItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusItem.h"

@implementation SchoolBusItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.lng = (CGFloat)[dict[@"lng"] doubleValue];
        self.lat = (CGFloat)[dict[@"lat"] doubleValue];
        self.busID = (CGFloat)[dict[@"id"] doubleValue];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
