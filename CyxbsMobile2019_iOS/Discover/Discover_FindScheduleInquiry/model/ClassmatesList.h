//
//  ClassmatesList.h
//  MoblieCQUPT_iOS
//
//  Created by 方昱恒 on 2019/9/27.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassmateItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassmatesList : NSObject

@property (nonatomic, copy) NSArray<ClassmateItem *> *classmatesArray;

- (void)getListWithName:(NSString *)name success:(void (^)(ClassmatesList *classmatesList))succeededCallBack failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failedCallBack;

@end

NS_ASSUME_NONNULL_END
