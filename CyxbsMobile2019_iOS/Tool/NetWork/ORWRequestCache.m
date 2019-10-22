//
//  SqliteCache.m
//  MoblieCQUPT_iOS
//
//  Created by user on 15/9/2.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "ORWRequestCache.h"
#import <FMDatabase.h>

@interface ORWRequestCache()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ORWRequestCache
static const NSString *dataBaseName = @"ORWCacheSqlite";

static const NSString *ORWPrimaryKeyUrl = @"request_url";
static const NSString *ORWPrimaryKeyParam = @"request_param";
static const NSString *ORWDataCol = @"data";
static const NSString *ORWDeadtimeCol = @"deadtime";
static const NSInteger ORWDeafultCacheTime = 60*60*6;

+ (NSString *)ORWRequestCacheDataBaseName {
    ORWRequestCache *cache = [[ORWRequestCache alloc]init];
    return [cache dataBaseName];
}

+ (NSString *)ORWRequestCacheFilePath {
    ORWRequestCache *cache = [[ORWRequestCache alloc]init];
    return [cache filePath];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.db = [FMDatabase databaseWithPath:[self filePath]];
        if ([self.db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('%@' TEXT PRIMARY KEY,'%@' TEXT PRIMARY KEY,'%@' BLOG, '%@' INTEGER)", self.dataBaseName,ORWPrimaryKeyUrl,ORWPrimaryKeyParam,ORWDataCol,ORWDeadtimeCol];
            
            BOOL isCreate = [self.db executeUpdate:sqlCreateTable];
            if (!isCreate) {
                NSLog(@"error when creating cache db table");
            }
            [self.db close];
        }
    }
    return self;
}

#pragma mark  /** 各个属性 **/
- (NSString *)dataBaseName{
    return [dataBaseName copy];
}

- (NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",self.dataBaseName,self.dataBaseNameEXT];
    NSString *dataFilePath = [documents stringByAppendingPathComponent:fileName];

    return dataFilePath;
}

- (NSString *)dataBaseNameEXT{
    if (!_dataBaseNameEXT) {
        _dataBaseNameEXT = [@"db" copy];
    }
    return _dataBaseNameEXT;
}

- (NSInteger)defaultCacheTime{
    if (!_defaultCacheTime) {
        return ORWDeafultCacheTime;
    }
    return _defaultCacheTime;
}


#pragma mark /** 查询相关 **/
/**
 *  @author Orange-W, 15-09-18 14:09:18
 *
 *  @brief  打印缓存列表
 *  @return 列表字段字典
 */
- (NSArray *)selectCacheDataList{
    return [self selectCacheDataWithSql:[NSString stringWithFormat:@"SELECT * FROM %@",self.dataBaseName]];
}

- (BOOL)isOutOfDateWithUrl:(NSString *)urlString{
    NSDictionary *fectchDictory= [self selectCacheDataWithUrl:urlString];
//    NSLog(@"%@",fectchDictory);
    if (fectchDictory) {
        NSInteger cacheDeadTime = (NSInteger)[fectchDictory objectForKey:ORWDeadtimeCol];
        NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"比较:现在%ld-记录%ld",(long)nowTime,(long)cacheDeadTime);
        return (cacheDeadTime>nowTime?YES:NO);
    }
    
    return YES;
}

/**
 *  @author Orange-W, 15-09-18 14:09:51
 *
 *  @brief  基本查询方法
 *  @param url url主键查找
 *  @return 请求的 data 数据字典
 */
- (NSDictionary *)selectCacheDataWithUrl:(NSString *)url{
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",self.dataBaseName,ORWPrimaryKeyUrl,url];
    return [[self selectCacheDataWithSql:selectSql] firstObject];
}


- (NSArray *)selectCacheDataWithSql:(NSString *)selectSql{
    
    if ([self.db open]) {
//        NSLog(@"sql:%@",selectSql);
        FMResultSet *result = [self.db executeQuery:selectSql];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        while([result next]) {
//            NSLog(@"提取数据");
            [returnArray addObject:[self fectchFirstDataFromResultSet:result]];
        }
        
        [self.db close];
        return [returnArray copy];
    }
    [self.db close];
    return nil;
}

- (NSDictionary *)fectchFirstDataFromResultSet:(FMResultSet *)resultSet
{
        NSString *requestUrl = [resultSet stringForColumn:[ORWPrimaryKeyUrl copy]];
        NSData *requestData = [resultSet dataForColumn:[ORWDataCol copy]];
        
        NSInteger deadtime = [resultSet intForColumn:[ORWDeadtimeCol copy]];
        NSDictionary *fectchDataDictory = @{@"request_url":requestUrl,
                                     @"request_data":requestData,
                                     @"deadtime":[NSNumber numberWithInteger:deadtime]};
//    NSLog(@"列值:%@", fectchDataDictory);
    return fectchDataDictory;
}


#pragma mark  /** 插入/跟新相关 **/
/**
 *  @author Orange-W, 15-09-18 14:09:43
 *
 *  @brief  基本缓存方法,使用默认缓存时间(6小时)
 *  @param dictionaryData 缓存的字典
 *  @param urlString      缓存地址,url 主键
 *  @return 成功/失败
 */
- (BOOL)saveDataWithDictionary:(NSDictionary *) dictionaryData
                           url:(NSString *) urlString{
    return [self saveDataWithDictionary:dictionaryData url:urlString cacheTime:self.defaultCacheTime];
}

/**
 *  @author Orange-W, 15-09-18 14:09:08
 *
 *  @brief  基本数据存储
 *  @param dictionaryData  数据字典
 *  @param urlString      网址
 *  @param second         缓存时间(秒)
 *  @return 成功/失败
 */
- (BOOL)saveDataWithDictionary:(NSDictionary *) dictionaryData
                           url:(NSString *) urlString
                     cacheTime:(NSInteger) second{
    second = second>0?:60*60*24*365;
    second += [[NSDate date] timeIntervalSince1970];
    
    NSString *updateSql = [NSString
                           stringWithFormat:@"REPLACE INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%ld')",
                           self.dataBaseName,
                           ORWPrimaryKeyUrl,
                           ORWDataCol,
                           ORWDeadtimeCol,
                           urlString,dictionaryData,(long)second];
    if ([self.db open]) {
        
        BOOL isUpdate = [self.db executeUpdate:updateSql];
        
        if (!isUpdate) {
            NSLog(@"error when insert cache db data");
        }else{
            [self.db close];
            return YES;
        }
    }
    [self.db close];
    return NO;
}

- (BOOL)updateDataWithSql:(NSString *)updateSql{
    if ([self.db open]) {
        BOOL isUpdate = [self.db executeUpdate:updateSql];
        
        if (!isUpdate) {
            NSLog(@"error when insert cache db data");
        }else{
            [self.db close];
            return YES;
        }
    }
    [self.db close];
    return NO;
}

#pragma mark  /** 获得当前时间格式 **/
- (NSDateComponents *) getNowDateComponents{
    NSDate *now = [NSDate date];
    NSDateComponents *comps;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}

@end
