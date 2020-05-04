//
//  IntegralStorePresenterProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IntegralStorePresenterProtocol <NSObject>

- (void)storeDataLoadSucceeded:(id)responseObject;
- (void)storeDataLoadFailed;

- (void)goodsOrderSuccess;
- (void)goodsOrderFailuer;

- (void)integralFreshSuccess;

@end

NS_ASSUME_NONNULL_END
