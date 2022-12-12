//
//  ScheduleCollectionViewLayoutAttributes.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewLayoutSupport.h"

@implementation ScheduleCollectionViewLayoutAttributes

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.pointIndexPath = self.pointIndexPath.copy;
    attributes.lenth = self.lenth;
    return attributes;
}

@end

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@implementation ScheduleCollectionViewLayoutInvalidationContext

@end
