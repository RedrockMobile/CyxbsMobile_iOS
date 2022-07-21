//
//  PMPFansFollowsAndPraiseModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/31.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMPFansFollowsAndPraiseModel : NSObject

// 这三个数据展示
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger follows;
@property (nonatomic, assign) NSInteger praise;
// 这两个数据不用展示
@property (nonatomic, assign) NSInteger comment;
@property (nonatomic, assign) NSInteger dynamic;

/// 得到数据
+ (void)getDataWithRedid:(NSString *)redid
                 success:(void (^)(PMPFansFollowsAndPraiseModel * model))success
                 failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
