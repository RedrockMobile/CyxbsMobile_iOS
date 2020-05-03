//
//  MyGoodsModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsModel : NSObject

+ (void)requestMyGoodsWithParams:(NSDictionary *)params
                         success:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
