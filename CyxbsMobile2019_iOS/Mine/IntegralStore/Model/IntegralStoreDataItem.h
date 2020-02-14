//
//  IntegralStoreDataItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegralStoreDataItem : NSObject

/// 商品名称
@property (nonatomic, copy) NSString *name;

/// 兑换所需积分
@property (nonatomic, copy) NSString *value;

/// 剩余数量
@property (nonatomic, copy) NSString *num;

/// 商品图片地址
@property (nonatomic, copy) NSString *photo_src;

/// 是否为虚拟商品
@property (nonatomic, copy) NSString *isVirtual;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
