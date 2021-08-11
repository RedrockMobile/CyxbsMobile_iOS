//
//  DetailsCommodityModel.h
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsCommodityModel : NSObject

@property (nonatomic, copy) NSString * commodity_name;
@property (nonatomic, assign) NSInteger price; 
@property (nonatomic, copy) NSString * date;
@property (nonatomic, strong) NSString * moment;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, copy) NSString * order_id;

+ (NSArray *)getDataList;

@end

NS_ASSUME_NONNULL_END
