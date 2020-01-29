//
//  MineModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQADataItem;
@interface MineModel : NSObject

+ (void)requestQADataSucceeded:(void (^)(MineQADataItem *responseItem))succeeded
                        failed:(void (^)(NSError *err))failed;

@end

NS_ASSUME_NONNULL_END
