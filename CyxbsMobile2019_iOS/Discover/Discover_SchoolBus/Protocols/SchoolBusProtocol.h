//
//  SchoolBusProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SchoolBusItem;

@protocol SchoolBusProtocol <NSObject>

- (void)schoolBusLocationRequestsSuccess:(NSArray<SchoolBusItem *> *)busArray;

@end

NS_ASSUME_NONNULL_END
