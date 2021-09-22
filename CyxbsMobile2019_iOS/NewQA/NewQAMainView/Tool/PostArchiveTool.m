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


+ (NSMutableArray *)getMyFollowGroup {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"group.data"];
    NSMutableArray *group = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
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

+ (void)savePostCellHeightWith:(NSMutableArray *)array {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"PostCellHeight.data"];
    [NSKeyedArchiver archiveRootObject:array toFile:perSavedSandPath];
}

+ (NSMutableArray *)getPostCellHeight {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"PostCellHeight.data"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:perSavedSandPath];
    return array;
}

+ (void)removePostModel {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"post.data"];
    [[NSFileManager defaultManager] removeItemAtPath:perSavedSandPath error:nil];
}

+ (void)removeGroupModel {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"group.data"];
    [[NSFileManager defaultManager] removeItemAtPath:perSavedSandPath error:nil];
}

+ (void)removeHotWordModel {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"hotWords.data"];
    [[NSFileManager defaultManager] removeItemAtPath:perSavedSandPath error:nil];
}

+ (void)removePostCellHeight {
    NSString *docSandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *perSavedSandPath = [docSandPath stringByAppendingPathComponent:@"PostCellHeight.data"];
    [[NSFileManager defaultManager] removeItemAtPath:perSavedSandPath error:nil];
}

@end

