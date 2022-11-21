//
//  ScheduleCollectionViewLayoutAttributes.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewLayoutAttributes.h"

#pragma mark - ScheduleCollectionViewLayoutAttributes

@implementation ScheduleCollectionViewLayoutAttributes

- (id)copyWithZone:(nullable NSZone *)zone {
    ScheduleCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.layoutModel = self.layoutModel.copy;
    return attributes;
}

@end

#pragma mark - ScheduleCollectionViewLayoutModel

@implementation ScheduleCollectionViewLayoutModel

- (id)copyWithZone:(NSZone *)zone {
    ScheduleCollectionViewLayoutModel *model = [[ScheduleCollectionViewLayoutModel alloc] init];
    model.title = self.title;
    model.content = self.content;
    model.hadMuti = self.hadMuti;
    model.week = self.week;
    model.orginRange = self.orginRange;
    return model;
}

@end

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@implementation ScheduleCollectionViewLayoutInvalidationContext

@end
