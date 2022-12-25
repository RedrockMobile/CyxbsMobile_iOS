//
//  ScheduleCollectionViewModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewModel.h"

#pragma mark - ScheduleCollectionViewModel

@implementation ScheduleCollectionViewModel

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleCollectionViewModel *model = [[ScheduleCollectionViewModel alloc] init];
    model.title = self.title.copy;
    model.content = self.content.copy;
    model.hadMuti = self.hadMuti;
    model.kind = self.kind;
    model.lenth = self.lenth;
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p> [len: %ld, kind: %ld, muti: %d] (%@ %@)", NSStringFromClass(self.class), self, self.lenth, self.kind, self.hadMuti, self.title, self.content];
}

@end



#pragma mark - ScheduleCollectionViewModel (ScheduleCourse)

@implementation ScheduleCollectionViewModel (ScheduleCourse)

- (instancetype)initWithScheduleCourse:(ScheduleCourse *)course {
    self = [super init];
    if (self) {
        self.title = course.course;
        self.content = course.classRoom;
        self.hadMuti = NO;
        self.kind = ScheduleBelongUnknow;
        self.lenth = course.period.length;
    }
    return self;
}

@end
