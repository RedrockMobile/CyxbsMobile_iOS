//
//  SZHArchiveTool.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/17.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**搜索页和发布动态页的网络数据缓存策略*/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZHArchiveTool : NSObject
//解、归档热搜view的按钮文本内容
+ (NSArray *)getHotWordsListAry;      //解档
+ (void)saveHotWordsList:(NSArray *)hotWordsListAry;    //归档

//发布动态页的标题内容
+ (NSArray *)getTopicsAry;
+ (void)saveTopicsAry:(NSArray *)topicsAry;

//发布动态页草稿图片
+ (NSArray *)getDraftsImagesAry;
+ (void)saveDraftsImagesAry:(NSArray *)ary;

//发布动态页草稿图片
+ (NSString *)getDraftsStr;
+ (void)saveDraftsStr:(NSString *)str;

//清除草稿内容
+ (void)removeDrafts;
@end

NS_ASSUME_NONNULL_END
