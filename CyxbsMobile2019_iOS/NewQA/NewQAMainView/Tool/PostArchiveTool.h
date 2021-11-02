//
//  PostArchiveTool.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupItem.h"
#import "GroupModel.h"
#import "PostItem.h"
#import "PostModel.h"
#import "HotSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostArchiveTool : NSObject

+ (NSMutableArray *)getPostList;

+ (void)savePostListWith:(NSMutableArray *)post;

+ (NSMutableArray *)getMyFollowGroup;

+ (void)saveMyFollowGroupWith:(NSMutableArray *)group;

+ (HotSearchModel *)getHotWords;

+ (void)savePostCellHeightWith:(NSMutableArray *)array;

+ (NSMutableArray *)getPostCellHeight;

+ (void)saveHotWordsWith:(HotSearchModel *)hotWords;

+ (void)removePostModel;

+ (void)removeGroupModel;

+ (void)removeHotWordModel;

+ (void)removePostCellHeight;

+ (void)removeNewMessageCountDictionary;

@end

NS_ASSUME_NONNULL_END
