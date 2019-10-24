//
//  LoginModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject

- (void)loginWithStuNum:(NSString *)stuNum andIdNum:(NSString *)idNum succeeded:(void (^)(NSDictionary *responseItem))succeeded failed:(void (^)(NSError *error))failed;

@end

NS_ASSUME_NONNULL_END
