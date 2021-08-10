//
//  DetailsTaskModel.h
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTaskModel : NSObject

@property (nonatomic, copy) NSString * task_name;
@property (nonatomic, assign) NSInteger gain_stamp;
@property (nonatomic, copy) NSString * date;

+ (NSArray *)getDatalist;

@end

NS_ASSUME_NONNULL_END
