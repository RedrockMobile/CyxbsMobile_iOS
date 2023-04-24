//
//  ScheduleDetailPartContext.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCombineItemSupport.h"
#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleDetailPartContext : NSObject <NSSecureCoding, NSCopying> {
@private
    ScheduleIdentifier *_key;
    ScheduleCourse *_course;
}

- (nullable instancetype)initWithKey:(nullable ScheduleIdentifier *)identifier course:(nullable ScheduleCourse *)course NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)contextWithKey:(nullable ScheduleIdentifier *)identifier course:(nullable ScheduleCourse *)course;

@property (readonly) ScheduleIdentifier *key;

@property (readonly) ScheduleCourse *course;

@end





@interface ScheduleDetailPartContext (Calender)

@property (nonatomic, readonly) NSString *keyTitle;

@property (nonatomic, readonly) NSString *calenderTitle;

@property (nonatomic, readonly) NSString *calenderContent;

@property (nonatomic, readonly) NSArray <NSDate *> *froms;

@property (nonatomic, readonly) NSTimeInterval continues;

@end

NS_ASSUME_NONNULL_END
