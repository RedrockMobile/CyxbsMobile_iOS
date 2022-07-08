//
//  NewCountModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);

@interface NewCountModel : NSObject

@property (nonatomic, copy) Netblock Block;

@property (nonatomic, strong) NSMutableArray *PostCountArray;

- (void)queryNewCountWithTimestamp:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
