//
//  GoodsData.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsData : NSObject

@property (nonatomic,assign) int id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) int amount;
@property (nonatomic,assign) int price;
@property (nonatomic,assign) int type;

+ (instancetype)GoodsDataWithDict:(NSDictionary *)dict;

+ (void)GoodsDataWithSuccess:(void(^)(NSArray *array))success error:(void(^)(void))error;

@end

NS_ASSUME_NONNULL_END
