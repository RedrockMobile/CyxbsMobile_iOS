//
//  MyGoodsItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/3.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsItem : NSObject

/// 图片地址
@property (nonatomic, copy) NSString *photo_src;

/// 商品名称
@property (nonatomic, copy) NSString *name;

/// 兑换时间
@property (nonatomic, copy) NSString *time;

/// 商品价格
@property (nonatomic, copy) NSString *value;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
