//
//  CheckInModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInModel.h"

@implementation CheckInModel

MJExtensionCodingImplementation

- (void)setCheckInDays:(NSArray<NSNumber *> *)checkInDays {
    _checkInDays = checkInDays;
    [NSKeyedArchiver archiveRootObject:self toFile:[CheckInModel archivePath]];
}

- (void)setContinuallyCheckInDays:(NSNumber *)continuallyCheckInDays {
    continuallyCheckInDays = continuallyCheckInDays;
    [NSKeyedArchiver archiveRootObject:self toFile:[CheckInModel archivePath]];
}

- (void)setCheckedInToday:(BOOL)checkedInToday {
    _checkedInToday = checkedInToday;
    [NSKeyedArchiver archiveRootObject:self toFile:[CheckInModel archivePath]];
}

+ (NSString *)archivePath {
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"CheckIn.data"];
}

+ (instancetype)model {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[CheckInModel archivePath]];
}

@end
