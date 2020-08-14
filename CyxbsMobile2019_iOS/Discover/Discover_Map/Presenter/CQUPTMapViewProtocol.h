//
//  CQUPTMapViewProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapDataItem, CQUPTMapHotPlaceItem, CQUPTMapStarPlaceItem, CQUPTMapSearchItem;
@protocol CQUPTMapViewProtocol <NSObject>

- (void)mapDataRequestSuccessWithMapData:(CQUPTMapDataItem *)mapData hotPlace:(NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceArray;

- (void)starPlaceRequestSuccessWithStarArray:(NSArray<CQUPTMapStarPlaceItem *> *)starPlaceArray;

- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray;

@end

NS_ASSUME_NONNULL_END
