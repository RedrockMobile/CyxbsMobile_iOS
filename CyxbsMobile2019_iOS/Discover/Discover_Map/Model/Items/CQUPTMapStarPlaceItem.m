//
//  CQUPTMapStarPlaceItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapStarPlaceItem.h"
#import "CQUPTMapPlaceItem.h"
#import "CQUPTMapDataItem.h"

@implementation CQUPTMapStarPlaceItem

MJExtensionCodingImplementation

+ (NSString *)archivePath {
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"CQUPTMapStarPlaceItem.data"];
}

- (void)archiveItem {
    [NSKeyedArchiver archiveRootObject:self toFile:[CQUPTMapStarPlaceItem archivePath]];
}

- (instancetype)initWithDice:(NSDictionary *)dict {
    if (self = [super init]) {
        self.starPlaceArray = [@[] mutableCopy];
        
        for (int i = 0; i < ((NSArray *)(dict[@"data"][@"place_id"])).count; i++) {
            [self.starPlaceArray addObject:[dict[@"data"][@"place_id"][i] stringValue]];
        }
    }
    return self;
}

+ (NSArray<CQUPTMapPlaceItem *> *)starPlaceDetail {
    CQUPTMapStarPlaceItem *starItem = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapStarPlaceItem archivePath]];
    CQUPTMapDataItem *mapData = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapDataItem archivePath]];
    
    NSMutableArray *tmpArray = [@[] mutableCopy];
    for (NSString *placeID in starItem.starPlaceArray) {
        for (CQUPTMapPlaceItem *place in mapData.placeList) {
            if ([placeID isEqualToString:place.placeId]) {
                [tmpArray addObject:place];
            }
        }
    }
    
    return [tmpArray copy];
}

@end
