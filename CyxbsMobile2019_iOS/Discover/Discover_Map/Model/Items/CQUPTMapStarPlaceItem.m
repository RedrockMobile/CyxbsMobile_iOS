//
//  CQUPTMapStarPlaceItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapStarPlaceItem.h"

@implementation CQUPTMapStarPlaceItem

- (instancetype)initWithDice:(NSDictionary *)dict {
    if (self = [super init]) {
        self.placeNickname = dict[@"place_nickname"];
        self.placeId = [dict[@"place_id"] stringValue];
    }
    return self;
}

@end
