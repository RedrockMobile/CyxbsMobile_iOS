//
//  ArchiveTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ArchiveTool.h"

@implementation ArchiveTool

///解档
+ (VolunteerItem *)getPersonalInfo{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"volunteer.data"];
    VolunteerItem *volunteer =   [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return volunteer;
}

///归档
+ (void)saveVolunteerInfomationWith:(VolunteerItem *)volunteer{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"volunteer.data"];
    [NSKeyedArchiver archiveRootObject:volunteer toFile:perSavedSandPath];
}

///删除
+ (void)deleteFile{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"volunteer.data"];
    [[NSFileManager defaultManager] removeItemAtPath:perSavedSandPath error:nil];
}

@end
