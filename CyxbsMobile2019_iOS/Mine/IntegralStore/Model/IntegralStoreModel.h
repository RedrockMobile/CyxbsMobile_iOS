//
//  IntegralStoreModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegralStoreModel : NSObject

- (void)loadStoreDataSucceeded:(void (^)(NSDictionary *responseObject))succeeded
                        failed:(void (^)(void))failed;

@end

NS_ASSUME_NONNULL_END
