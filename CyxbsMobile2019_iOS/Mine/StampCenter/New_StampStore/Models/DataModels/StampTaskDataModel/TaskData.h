//
//  StampTaskData.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TaskData : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int max_progress;
@property (nonatomic,assign) int current_progress;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) int gain_stamp;

+ (instancetype)TaskDataWithDict:(NSDictionary *)dict;

+ (void)TaskDataWithSuccess:(void(^)(NSArray *array))success error:(void(^)(void))error;

@end

NS_ASSUME_NONNULL_END
