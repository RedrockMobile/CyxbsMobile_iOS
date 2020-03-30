//
//  SchoolBusModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SchoolBusModel : NSObject

- (void)requestSchoolBusLocation:(NSString *)url
                         success:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
