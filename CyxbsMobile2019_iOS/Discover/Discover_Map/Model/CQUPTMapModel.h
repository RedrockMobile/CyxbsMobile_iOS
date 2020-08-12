
//  CQUPTMapModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQUPTMapDataItem.h"
#import "CQUPTMapHotPlaceItem.h"
#import "CQUPTMapStarPlaceItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQUPTMapModel : NSObject

+ (void)requestMapDataSuccess:(void (^)(CQUPTMapDataItem *mapDataItem, NSArray<CQUPTMapHotPlaceItem *> *hotPlaceItemArray))success
                       failed:(void (^)(NSError *error))failed;

+ (void)requestHotPlaceSuccess:(void (^)(NSArray<CQUPTMapHotPlaceItem *> *hotPlaceItemArray))success;

+ (void)requestStarListSuccess:(void (^)(NSArray<CQUPTMapStarPlaceItem *> *starPlaceArray))success
                        failed:(void (^)(NSError *error))failed;;

@end

NS_ASSUME_NONNULL_END
