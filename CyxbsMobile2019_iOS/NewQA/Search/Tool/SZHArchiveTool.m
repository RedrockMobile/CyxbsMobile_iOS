//
//  SZHArchiveTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHArchiveTool.h"

@implementation SZHArchiveTool
//解档
+ (NSArray *)getHotWordsListAry{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"hotWordsList.data"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return array;
}
//归档
+ (void)saveHotWordsList:(NSArray *)hotWordsListAry{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"hotWordsList.data"];
    [NSKeyedArchiver archiveRootObject:hotWordsListAry toFile:perSavedSandPath];
    
}

//发布动态页的标题内容
+ (NSArray *)getTopicsAry{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"topics.data"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return array;
}
+ (void)saveTopicsAry:(NSArray *)topicsAry{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"topics.data"];
    [NSKeyedArchiver archiveRootObject:topicsAry toFile:perSavedSandPath];
}

//发布动态页草稿内容
+ (NSArray *)getDraftsImagesAry{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"draftsImages.data"];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return ary;
}
+ (void)saveDraftsImagesAry:(NSArray *)ary{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"draftsImages.data"];
    [NSKeyedArchiver archiveRootObject:ary toFile:perSavedSandPath];
}

+ (NSString *)getDraftsStr{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"draftsStr.data"];
    NSString *str = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return str;
}
+ (void)saveDraftsStr:(NSString *)str{
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"draftsStr.data"];
    [NSKeyedArchiver archiveRootObject:str toFile:perSavedSandPath];
}

+ (void)removeDrafts{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //清除图片
    NSString *docSandPath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath1 = [docSandPath1 stringByAppendingPathComponent:@"draftsImages.data"];
    if ([fileManager fileExistsAtPath:perSavedSandPath1]) {
        NSError *error;
        [fileManager removeItemAtPath:perSavedSandPath1 error:&error];
    }
    
    //清除文本
    NSString *docSandPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath2 = [docSandPath2 stringByAppendingPathComponent:@"draftsStr.data"];
    if ([fileManager fileExistsAtPath:perSavedSandPath2]) {
        NSError *error;
        [fileManager removeItemAtPath:perSavedSandPath2 error:&error];
    }
}
@end
