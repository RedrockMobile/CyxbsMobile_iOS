//
//  StampCountData.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StampCountData : NSObject

@property (nonatomic,strong) NSNumber *count;

+ (void)getStampCountData:(void(^)(NSNumber *count))success;

@end

NS_ASSUME_NONNULL_END
