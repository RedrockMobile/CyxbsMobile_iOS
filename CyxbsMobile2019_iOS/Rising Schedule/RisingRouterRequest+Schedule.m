//
//  RisingRouterRequest+Schedule.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "RisingRouterRequest+Schedule.h"

#import "ScheduleRouterProtocol.h"

#pragma mark - ScheduleRouterParameter

@interface ScheduleRouterParameter : NSObject <ScheduleRouterProtocol>

/// 参数
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation ScheduleRouterParameter

- (instancetype)init {
    self = [super init];
    if (self) {
        _dic = NSMutableDictionary.dictionary;
    }
    return self;
}

- (nonnull id<ScheduleRouterProtocol> _Nonnull (^)(BOOL))allowCustomPan {
    return ^id<ScheduleRouterProtocol> (BOOL needPan) {
        self.dic[@"allowCustomPan"] = @(needPan);
        self.dic[@"viewController"] = @YES;
        return self;
    };
}

- (nonnull id<ScheduleRouterProtocol> _Nonnull (^)(NSDictionary<ScheduleModelRequestType,NSArray<NSString *> *> * _Nonnull))request {
    return ^id<ScheduleRouterProtocol> (NSDictionary<ScheduleModelRequestType,NSArray<NSString *> *> * dic){
        self.dic[@"requestModel"] = dic;
        return self;
    };
}

- (id<ScheduleRouterProtocol> _Nonnull (^)(BOOL))needCustomFirst {
    return ^id<ScheduleRouterProtocol> (BOOL needCustomFirst) {
        self.dic[@"custom"] = @(YES);
        return self;
    };
}

@end

#pragma mark - RisingRouterRequest (Schedule)

@implementation RisingRouterRequest (Schedule)

+ (instancetype)requestWithScheduleBolck:(void (^)(id<ScheduleRouterProtocol> _Nonnull))block {
    RisingRouterRequest *request;
    
    if (block) {
        
        ScheduleRouterParameter *parameter = [[ScheduleRouterParameter alloc] init];
        block(parameter);
        
        request = [RisingRouterRequest requestWithRouterPath:ScheduleRouterName parameters:parameter.dic];
        
    } else {
        
        request =
        [RisingRouterRequest
         requestWithRouterPath:ScheduleRouterName
         parameters:@{
            @"allowCustomPan" : @YES,
            @"viewController" : @YES,
            @"requestModel" : @{
                ScheduleModelRequestStudent : @[UserItemTool.defaultItem.stuNum]
            }
        }];
        
    }
        
    return request;
}

@end

