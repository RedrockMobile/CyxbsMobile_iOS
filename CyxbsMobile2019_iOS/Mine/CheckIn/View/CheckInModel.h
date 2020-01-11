//
//  CheckInModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckInModel : NSObject

@property (nonatomic, copy) NSArray<NSNumber *> *checkInDays;
@property (nonatomic, strong) NSNumber *continuallyCheckInDays;
@property (nonatomic, assign) BOOL checkedInToday;

+ (NSString *)archivePath;

@end

NS_ASSUME_NONNULL_END
