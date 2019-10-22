//
//  NSNull+Helper.m
//  MoblieCQUPT_iOS
//
//  Created by GQuEen on 16/5/10.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "NSNull+Helper.h"
#define NSNullObjects @[@"",@0,@{},@[]]

@implementation NSNull (Helper)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (NSObject *object in NSNullObjects)
    {
        if ([object respondsToSelector:aSelector]) {
            return object;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
