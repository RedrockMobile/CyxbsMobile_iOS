

//  SqliteCache.h
//  MoblieCQUPT_iOS
//
//  Created by user on 15/9/2.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORWRequestCache : NSObject

typedef NS_ENUM(NSInteger, ORWCacheOption){
    ORWCacheOptionNone = 1,
};

@property (copy, nonatomic, readonly) NSString *dataBaseName;
@property (copy, nonatomic, readonly) NSString *filePath;
@property (copy, nonatomic) NSString *dataBaseNameEXT;
@property (assign, nonatomic) NSInteger defaultCacheTime;//second

+ (NSString *)ORWRequestCacheDataBaseName;
+ (NSString *)ORWRequestCacheFilePath;

- (NSString *)dataBaseName;
- (NSString *)filePath;

- (BOOL)isOutOfDateWithUrl:(NSString *)urlString;
- (NSDictionary *)selectCacheDataList;
- (NSDictionary *)selectCacheDataWithUrl:(NSString *)url;

- (BOOL)saveDataWithDictionary:(NSDictionary *) dictionaryData
                           url:(NSString *) urlString;
- (BOOL)saveDataWithDictionary:(NSDictionary *) dictionaryData
                           url:(NSString *) urlString
                     cacheTime:(NSInteger) second;

- (NSDateComponents *) getNowDateComponents;//当前时间各信息
@end
