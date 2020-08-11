//
//  CQUPTMapModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQUPTMapDataItem.h"
#import "CQUPTMapHotPlaceItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQUPTMapModel : NSObject

+ (void)requestMapDataSuccess:(void (^)(CQUPTMapDataItem *mapDataItem, CQUPTMapHotPlaceItem *hotPlaceItem))success failed:(void (^)(NSError *error))failed;

+ (void)requestHotPlaceSuccess:(void (^)(CQUPTMapHotPlaceItem *hotPlaceItem))success;

@end

NS_ASSUME_NONNULL_END
