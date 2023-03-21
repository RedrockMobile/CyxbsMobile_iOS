//
//  AttitudeSelfPageDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/19.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 获取个人中心数据Model
@interface AttitudeSelfPageDataModel : NSObject

- (void)requestAttitudeDataWithOffset:(NSInteger)offset
                                Limit:(NSInteger)limit
                              Success:(void (^)(NSArray *array))success
                              Failure:(void (^)(void))falure;
@end

NS_ASSUME_NONNULL_END
