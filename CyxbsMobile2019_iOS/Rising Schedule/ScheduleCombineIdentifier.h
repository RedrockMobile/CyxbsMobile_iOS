//
//  ScheduleCombineIdentifier.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleRequestType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCombineIdentifier : NSObject <NSCopying>

/// set as sno cause the key use
@property (nonatomic, readonly, copy) NSString *sno;

/// set cause the key use
@property (nonatomic, readonly, copy) ScheduleModelRequestType type;

/// save the time begin
@property (nonatomic) NSTimeInterval exp;
- (void)setExpWithNowWeek:(NSInteger)nowWeek;

/// you can save last request time
@property (nonatomic) NSTimeInterval iat;

/// return type + name
@property (nonatomic, readonly, copy) NSString *key;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString *)name type:(ScheduleModelRequestType)type;

@end

NS_ASSUME_NONNULL_END
