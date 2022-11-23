//
//  NSIndexPath+Schedule.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/21.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NSIndexPath+Schedule.h"

@implementation NSIndexPath (Schedule)

+ (instancetype)indexPathForLocation:(NSInteger)location inWeek:(NSInteger)week inSection:(NSInteger)section {
    NSUInteger indexes[] = {section, week, location};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:3];
    return indexPath;
}

- (NSInteger)section {
    return [self indexAtPosition:0];
}

- (NSInteger)week {
    return [self indexAtPosition:1];
}

- (NSInteger)location {
    return [self indexAtPosition:2];
}

@end
