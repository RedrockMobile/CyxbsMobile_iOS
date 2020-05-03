//
//  MyGoodsProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MyGoodsItem;
@protocol MyGoodsProtocol <NSObject>

- (void)myGoodsDataRequestsSuccessWithRecievedArray:(NSArray<MyGoodsItem *> *) recievd
                             andDidNotRecievedArray:(NSMutableArray<MyGoodsItem *> *) didNotRicieved;

- (void)myGoodsDataRequestsFailure:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
