//
//  IDDataManager.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/11/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDDataManager.h"
#import <FMDB.h>
#import "SQLCodeCreater.h"
//是否开启CCLog
#define CCLogEnable 1

// 获取认证身份
#define GetAuthentication @"magipoke-identity/GetAuthentication"

// 获取个性化身份
#define GetCustomization @"magipoke-identity/GetCustomization"

// 获取全部身份
#define GetAllIdentify @"magipoke-identity/GetAllIdentify"

// 获取展示身份
#define GetShowIdentify @"magipoke-identity/GetShowIdentify"

// 上传动态展示身份
#define UploadDisplayIdentity @"magipoke-identity/UploadDisplayIdentity"

// 删除身份
#define DeleteIdentity @"magipoke-identity/DeleteIdentity"

//全部ID的目录路径
#define idDBPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/IDDBPath"]

//magipoke/person/info
//用来生成 NSString
#define OSTRING(str) @#str

//认证身份表
#define autIDTable @"autIDTable"
//个性身份表
#define cusIDTable @"cusIDTable"
//展示身份表
#define dispIDTable @"dispIDTable"

//身份ID
#define idStr_SQLP @"idStr_SQLP"
//发布身份的部门
#define departmentStr_SQLP @"departmentStr_SQLP"
//该身份在该部门代表的职位
#define positionStr_SQLP @"positionStr_SQLP"
//身份有效期
#define validDateStr_SQLP @"validDateStr_SQLP"
//身份的背景图片
#define bgImgURLStr_SQLP @"bgImgURLStr_SQLP"
//身份的类型，认证身份，或者个性身份
#define idTypeStr_SQLP @"idTypeStr_SQLP"
//是否是展示身份
#define isshow_SQLP @"isshow_SQLP"
//是否已经过期
#define islate_SQLP @"islate_SQLP"

@interface IDDataManager ()
//用 FMDatabaseQueue 而不是直接用 FMDatabase 的好处是可以避免多线程问题
@property (nonatomic, strong) FMDatabaseQueue *idDBQue;
@end

@implementation IDDataManager

//MARK: - 实现单例必要的方法：
static IDDataManager* _IDDataManagerInstance = nil;
static dispatch_once_t _IDDataManagerDispatchOnceToken = 0;

+ (instancetype)shareManager {
    if (_IDDataManagerInstance==nil) {
        [self allocWithZone:nil];
        //初始化
    }
    return _IDDataManagerInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    //在allocWithZone内部调用任何会产生新实例对象的方法，都要避免死递归的发生，
    //因为产生新对象必定会调用allocWithZone：
    dispatch_once(&_IDDataManagerDispatchOnceToken, ^{
        //用其他alloc方法会崩溃，因为循环调用同一个dispatch_once
        _IDDataManagerInstance = [[super allocWithZone:nil] init];
        if (_IDDataManagerInstance) {
            //初始化
            [_IDDataManagerInstance createAllTable];
        }
    });
    return _IDDataManagerInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _IDDataManagerInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _IDDataManagerInstance;
}
    
/// 退出登录时调用，使这个单例可以被再次创建
- (void)logOut {
    _IDDataManagerInstance = nil;
    _IDDataManagerDispatchOnceToken = 0;
}





//MARK: - 业务逻辑代码：
/// 建表
- (void)createAllTable {
    self.idDBQue = [FMDatabaseQueue databaseQueueWithPath:idDBPath];
    [self.idDBQue inDatabase:^(FMDatabase * _Nonnull db) {
        NSDictionary<SQLPropertyType,NSArray<NSString *> *> * propertyDict = @{
            SQLPropertyTypeString : @[idStr_SQLP, departmentStr_SQLP, positionStr_SQLP, validDateStr_SQLP, bgImgURLStr_SQLP, idTypeStr_SQLP],
            SQLPropertyTypeInt : @[isshow_SQLP, islate_SQLP],
        };
        NSArray *restrainStrArr = @[[NSString stringWithFormat:@"PRIMARY KEY(%@)", idStr_SQLP]];
        NSArray *tableNameArr = @[autIDTable, cusIDTable, dispIDTable];
        NSString *code;
        
        for (NSString *tableName in tableNameArr) {
            code = [SQLCodeCreater createTable:tableName withPropertyDict:propertyDict restrainStrArr:restrainStrArr];
            [db executeUpdate:code];
        }
    }];
    //++++++++++++++++++debug++++++++++++++++++++  Begain
#ifdef DEBUG
    [self addTestData];
#endif
    //++++++++++++++++++debug++++++++++++++++++++  End
}
- (NSArray<IDModel *> *)getTestDataArrWithType:(IDModelIDType)idTypeStr {
    NSMutableArray<IDModel *> *arr = [NSMutableArray<IDModel*> array];
    const int testCnt = 4;
    for (int i = 0; i < testCnt; ++i) {
        IDModel *model = [[IDModel alloc] init];
        model.idStr = [NSString stringWithFormat:@"%u", arc4random_uniform(300) + 5000];
        model.departmentStr = @"部门";
        model.positionStr = @"职位";
        model.validDateStr = @"2023.2.2";
//        model.bgImgURLStr = @"http://cdn1.redrock.team/magipoke_2020211614_1632900390.png";
        model.islate = NO;
        model.idTypeStr = idTypeStr;
        model.isshow = NO;
        double r = arc4random_uniform(150)/300.0;
        double g = arc4random_uniform(150)/300.0;
        double b = arc4random_uniform(150)/300.0;
        model.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [arr addObject:model];
    }
    return arr;
}

- (void)addTestData {
    return;
    NSMutableArray<IDModel *> *arr = [NSMutableArray<IDModel*> array];
    const int testCnt = 4;
    for (int i = 0; i < testCnt; ++i) {
        IDModel *model = [[IDModel alloc] init];
        model.idStr = [NSString stringWithFormat:@"%u", arc4random_uniform(300) + 5000];
        model.departmentStr = @"部门";
        model.positionStr = @"职位";
        model.validDateStr = @"2023.2.2";
        model.bgImgURLStr = @"http://cdn1.redrock.team/magipoke_2020211614_1632900390.png";
        model.islate = NO;
        model.idTypeStr = IDModelIDTypeAut;
        model.isshow = NO;
        double r = arc4random_uniform(150)/300.0;
        double g = arc4random_uniform(150)/300.0;
        double b = arc4random_uniform(150)/300.0;
        model.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [arr addObject:model];
    }
    [self storeIDDataFromArr:arr inTable:autIDTable];
    
    [arr removeAllObjects];
    for (int i = 0; i < testCnt; ++i) {
        IDModel *model = [[IDModel alloc] init];
        model.idStr = [NSString stringWithFormat:@"%u", arc4random_uniform(300) + 5000];
        model.departmentStr = @"部门";
        model.positionStr = @"职位";
        model.validDateStr = @"2023.2.2";
        model.bgImgURLStr = @"http://cdn1.redrock.team/magipoke_2020211614_1632900390.png";
        model.islate = NO;
        model.idTypeStr = IDModelIDTypeCus;
        model.isshow = NO;
        double r = arc4random_uniform(150)/300.0;
        double g = arc4random_uniform(150)/300.0;
        double b = arc4random_uniform(150)/300.0;
        model.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [arr addObject:model];
    }
    [self storeIDDataFromArr:arr inTable:cusIDTable];
}

//MARK: - 网络请求
/// 获取全部的身份，包括认证身份和个性身份
- (void)loadAllIDWithRedid:(NSString *)redid
                   success:(void (^)(NSMutableArray<IDModel *> * _Nonnull))success
                   failure:(void (^)(void))failure {
    if (redid==nil || [redid isEqualToString:@""]) {
        if (failure) { failure(); }
        return;
    }
    CCLog(@"%@", [self getUserWithTailURL:GetAllIdentify]);
    AFHTTPSessionManager *man = [self getHttpManager];
    [man GET:[self getUserWithTailURL:GetAllIdentify] parameters:@{
        @"id":redid
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if(![responseObject[@"info"] isEqual:@"success"]) {
            if (failure) { failure(); }
            CCLog(@"error::%@", responseObject);
        }else {
            NSDictionary *dict = responseObject[@"data"];
            NSArray *autArr = dict[@"authentication"];
            NSArray *cusArr = dict[@"customization"];
            NSMutableArray *autModelArr = [NSMutableArray arrayWithCapacity:autArr.count+1];
            NSMutableArray *cusModelArr = [NSMutableArray arrayWithCapacity:cusArr.count+1];
            for (NSDictionary *idDict in autArr) {
                [autModelArr addObject:[IDModel mj_objectWithKeyValues:idDict]];
            }
            for (NSDictionary *idDict in cusArr) {
                [cusModelArr addObject:[IDModel mj_objectWithKeyValues:idDict]];
            }
            NSMutableArray<IDModel*>*modelArr = [NSMutableArray arrayWithCapacity:autArr.count+cusArr.count+1];
            [modelArr addObjectsFromArray:autModelArr];
            [modelArr addObjectsFromArray:cusModelArr];
            
            //避免由于外界异步修改modelArr而导致崩溃
            NSArray<IDModel*>* autModelArrToStore = [autModelArr copy];
            NSArray<IDModel*>* cusModelArrToStore = [cusModelArr copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self storeIDDataFromArr:autModelArrToStore inTable:autIDTable];
                [self storeIDDataFromArr:cusModelArrToStore inTable:cusIDTable];
            });
            CCLog(@"success::%@", responseObject);
            if (success) { success(modelArr); }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) { failure(); }
        CCLog(@"error::%@", error);
    }];
}

/// 获取全部的认证身份
- (void)loadAuthenticIDWithRedid:(NSString *)redid
                         success:(void(^)(NSMutableArray <IDModel*> *modelArr))success
                         failure:(void(^)(void))failure {
    if (redid==nil || [redid isEqualToString:@""]) {
        if (failure) { failure(); }
        return;
    }
    AFHTTPSessionManager *man = [self getHttpManager];
    [man GET:[self getUserWithTailURL:GetAuthentication] parameters:@{
        @"id":redid
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if(![responseObject[@"info"] isEqual:@"success"]) {
            if (failure) { failure(); }
            CCLog(@"error::%@", responseObject);
        }else {
            NSArray *idArr = responseObject[@"data"];
            NSMutableArray<IDModel*>*modelArr = [NSMutableArray arrayWithCapacity:idArr.count+1];
            for (NSDictionary *idDict in idArr) {
                [modelArr addObject:[IDModel mj_objectWithKeyValues:idDict]];
            }
            
            //避免由于外界异步修改modelArr而导致崩溃
            NSArray<IDModel*>* modelArrToStore = [modelArr copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self storeIDDataFromArr:modelArrToStore inTable:autIDTable];
            });
            if (success) { success(modelArr); }
            CCLog(@"success::%@", responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) { failure(); }
        CCLog(@"error::%@", error);
    }];
}

/// 获取全部的个性身份
- (void)loadCustomIDWithRedid:(NSString *)redid
                      success:(void(^)(NSMutableArray <IDModel*> *modelArr))success
                      failure:(void(^)(void))failure {
    if (redid==nil || [redid isEqualToString:@""]) {
        if (failure) { failure(); }
        return;
    }
    AFHTTPSessionManager *man = [self getHttpManager];
    [man GET:[self getUserWithTailURL:GetCustomization] parameters:@{
        @"id":redid
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if(![responseObject[@"info"] isEqual:@"success"]) {
            if (failure) { failure(); }
            CCLog(@"error::%@", responseObject);
        }else {
            NSArray *idArr = responseObject[@"data"];
            NSMutableArray<IDModel*>*modelArr = [NSMutableArray arrayWithCapacity:idArr.count+1];
            for (NSDictionary *idDict in idArr) {
                [modelArr addObject:[IDModel mj_objectWithKeyValues:idDict]];
            }
            
            //避免由于外界异步修改modelArr而导致崩溃
            NSMutableArray<IDModel*>* modelArrToStore = [modelArr copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self storeIDDataFromArr:modelArrToStore inTable:cusIDTable];
            });
            
            if (success) { success(modelArr); }
            CCLog(@"success::%@", responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) { failure(); }
        CCLog(@"error::%@", error);
    }];
}

/// 获取展示的身份
- (void)loadDisplayIDWithRedid:(NSString *)redid
                       success:(void(^)(IDModel *model))success
                       failure:(void(^)(void))failure {
    if (redid==nil || [redid isEqualToString:@""]) {
        if (failure) { failure(); }
        return;
    }
    AFHTTPSessionManager *man = [self getHttpManager];
    [man GET:[self getUserWithTailURL:GetShowIdentify] parameters:@{
        @"id":redid
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if(![responseObject[@"info"] isEqual:@"success"]) {
            if (failure) { failure(); }
            CCLog(@"error::%@", responseObject);
        }else {
            NSDictionary *idDict = responseObject[@"data"];
            IDModel *model = [IDModel mj_objectWithKeyValues:idDict];
            if (model) {
                [self storeIDDataFromArr:@[model] inTable:dispIDTable];
            }
            if (success) { success(model); }
            CCLog(@"success::%@", responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CCLog(@"error::%@", error);
        if (failure) { failure(); }
    }];
}

/// 将id为idStr的身份设置成要展示的身份
- (void)displayIDWithModel:(IDModel*)model
                   success:(void(^)(void))success
                   failure:(void(^)(void))failure {
    AFHTTPSessionManager *man = [self getHttpManager];
    [man POST:[self getUserWithTailURL:UploadDisplayIdentity] parameters:@{
        @"identityId":model.idStr
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"info"] isEqualToString:@"success"]) {
            [self storeIDDataFromArr:@[model] inTable:dispIDTable];
            if (success) { success(); }
            CCLog(@"success::%@", responseObject);
        }else {
            if (failure) { failure(); }
            CCLog(@"error::%@", responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) { failure(); }
        CCLog(@"%@",error);
    }];
}

/// 将id为idStr的身份删除
- (void)deleteIDWithIDstr:(NSString*)idStr
                  success:(void(^)(void))success
                  failure:(void(^)(void))failure {
    AFHTTPSessionManager *man = [self getHttpManager];
    [man POST:[self getUserWithTailURL:DeleteIdentity] parameters:@{
        @"identityId":idStr
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) { success();}
        CCLog(@"resp::%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) { failure(); }
        CCLog(@"error::%@", error);
    }];
}


//MARK: - 在本地进行的操作
/// 从本地数据库获取认证身份
- (nullable NSMutableArray<IDModel*>*)getAutIDModelArrFromLocal {
    return [self getAllSortedModelFromTable:autIDTable];
}

/// 从本地数据库获取个性身份
- (nullable NSMutableArray<IDModel*>*)getCusIDModelArrFromLocal {
    return [self getAllSortedModelFromTable:cusIDTable];
}

/// 从本地数据库获取展示身份
- (nullable IDModel*)getDispIDModelFromLocal {
    return [self getAllSortedModelFromTable:dispIDTable].firstObject;
}


//MARK: - 其他工具方法
- (void)storeIDDataFromArr:(NSArray<IDModel*>*)modelArr inTable:(NSString*)tableName {
    [self.idDBQue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *code;
        code = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        [db executeUpdate:code];
        for (IDModel *model in modelArr) {
            code = [SQLCodeCreater insertTable:tableName withPropertyNameArr:@[idStr_SQLP, departmentStr_SQLP, positionStr_SQLP, validDateStr_SQLP, bgImgURLStr_SQLP, idTypeStr_SQLP, islate_SQLP, isshow_SQLP]];
            [db executeUpdate:code withArgumentsInArray:@[model.idStr, model.departmentStr, model.positionStr, model.validDateStr, model.bgImgURLStr, model.idTypeStr, @(model.islate), @(model.isshow)]];
        }
    }];
}

/// 进行 URL 的拼接
- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}
/// 获取一个在当前这个页面通用的 AFHTTPSessionManager
- (AFHTTPSessionManager*)getHttpManager {
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 15.0;
    NSString *token = [UserItem defaultItem].token;
    if (token) {
        [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    }
    [man setRequestSerializer:requestSerializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];
    [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/x-www-form-urlencoded", nil]];
    
    //++++++++++++++++++debug++++++++++++++++++++  Begain
    //因为运维的证书过期了，所以更改了安全策略
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    man.securityPolicy = policy;
    policy.allowInvalidCertificates = YES;
    [policy setValidatesDomainName:NO];
    //++++++++++++++++++debug++++++++++++++++++++  End
    return man;
}

/// 从 tableName 中获取全部的数据，并以 IDModel 数组的形式返回
- (NSMutableArray<IDModel*>*)getAllSortedModelFromTable:(NSString*)tableName {
    NSMutableArray<IDModel*>*modelArr = [NSMutableArray arrayWithCapacity:10];
    [self.idDBQue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *code = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
        FMResultSet *resultSet = [db executeQuery:code];
        while ([resultSet next]) {
            [modelArr addObject:[self getModelWithResultSet:resultSet]];
        }
    }];
    return modelArr;
}

/// 在 tableName 中通过 idStr 进行查询
- (IDModel*)getModelWithIDstr:(NSString*)idStr inTable:(NSString*)tableName {
    __block IDModel *model;
    [self.idDBQue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *code = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%@", tableName, idStr_SQLP, idStr];
        FMResultSet *resultSet = [db executeQuery:code];
        if ([resultSet next]) {
            model = [self getModelWithResultSet:resultSet];
        }
    }];
    return model;
}

/// 把 resultSet 转化为 IDModel
- (IDModel*)getModelWithResultSet:(FMResultSet*)resultSet {
    IDModel *model = [[IDModel alloc] init];
    model.idStr = [resultSet stringForColumn:idStr_SQLP];
    model.departmentStr = [resultSet stringForColumn:departmentStr_SQLP];
    model.positionStr = [resultSet stringForColumn:positionStr_SQLP];
    model.validDateStr = [resultSet stringForColumn:validDateStr_SQLP];
    model.bgImgURLStr = [resultSet stringForColumn:bgImgURLStr_SQLP];
    model.idTypeStr = [resultSet stringForColumn:idTypeStr_SQLP];
    model.isshow = [resultSet boolForColumn:isshow_SQLP];
    model.islate = [resultSet boolForColumn:islate_SQLP];
    return model;
}

/// 调试用
- (void)logTable:(NSString*)tableName {
    CCLog(@"%@", [self getAllSortedModelFromTable:tableName]);
}

@end

/*
 bug 及解决：
 网络请求成功后执行success(modelArr)回调。后调用-storeIDDataFromArr:inTable:存储数据。
 在 [self storeIDDataFromArr:modelArr inTable:xxxTable] 方法内使用了for-in进行遍历存储。
 而success内部对modelArr的处理是异步的，并且存在移除modelArr内元素的操作，因而导致在for-in遍历期间
 移出数组元素。
 解决：调用storeIDDataFromArr时传入copy过的数组
 */
