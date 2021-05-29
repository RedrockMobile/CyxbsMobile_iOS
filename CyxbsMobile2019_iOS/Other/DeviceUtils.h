//
//  DeviceUtils.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/5/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DeviceType) {
    Unknown = 0,
    Simulator,
    IPhone_1G,          //基本不用
    IPhone_3G,          //基本不用
    IPhone_3GS,         //基本不用
    IPhone_4,           //基本不用
    IPhone_4s,          //基本不用
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
    iPhone_XR,
    iPhone_XS,
    iPhone_XS_Max,
};

@interface DeviceUtils : NSObject
@property (nonatomic, assign, readonly, class)DeviceType deviceType;
@end

NS_ASSUME_NONNULL_END
