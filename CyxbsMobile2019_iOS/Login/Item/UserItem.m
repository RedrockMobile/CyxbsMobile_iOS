//
//  UserItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

MJExtensionCodingImplementation

static UserItem *item = nil;
+ (UserItem *)defaultItem {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSKeyedUnarchiver unarchiveObjectWithFile:[UserItemTool userItemPath]];
    });
    return item;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [super allocWithZone:zone];
    });
    return item;
}

@end
