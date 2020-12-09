//
//  ArchiveTool.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VolunteerItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveTool : NSObject

+ (VolunteerItem *)getPersonalInfo;

+ (void)saveVolunteerInfomationWith:(VolunteerItem *)volunteer;

+ (void)deleteFile;

@end

NS_ASSUME_NONNULL_END
