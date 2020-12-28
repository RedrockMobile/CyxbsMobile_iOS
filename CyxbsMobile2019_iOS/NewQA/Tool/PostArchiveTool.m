//
//  PostArchiveTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostArchiveTool.h"

@implementation PostArchiveTool


///解档
+ (NSMutableArray *)getPostList {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"post.data"];
    NSMutableArray *post = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return post;
}

///归档
+ (void)savePostListWith:(NSMutableArray *)post {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"post.data"];
    [NSKeyedArchiver archiveRootObject:post toFile:perSavedSandPath];
}


+ (GroupModel *)getMyFollowGroup {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"group.data"];
    GroupModel *group = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return group;
}

+ (void)saveMyFollowGroupWith:(GroupModel *)group {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"group.data"];
    [NSKeyedArchiver archiveRootObject:group toFile:perSavedSandPath];
}

+ (HotSearchModel *)getHotWords {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"hotWords.data"];
    HotSearchModel *hotWords = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return hotWords;
}

+ (void)saveHotWordsWith:(HotSearchModel *)hotWords {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"hotWords.data"];
    [NSKeyedArchiver archiveRootObject:hotWords toFile:perSavedSandPath];
}

+ (void)removePostModel {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"post.data"];
    if ([fileManager fileExistsAtPath:perSavedSandPath]) {
        NSError *err;
        [fileManager removeItemAtPath:perSavedSandPath error:&err];
    }
}

@end

