//
//  IDDataManager.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/11/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IDDataManager : NSObject

/// 根据redid得到全部身份
- (void)loadAllIDWithRedid:(NSString *)redid success:(void(^)(NSMutableArray <IDModel*> *modelArr))success failure:(void(^)(void))failure;

/// 获取全部的认证身份
- (void)loadAuthenticIDWithRedid:(NSString *)redid success:(void(^)(NSMutableArray <IDModel*> *modelArr))success failure:(void(^)(void))failure;

/// 获取全部的个性身份
- (void)loadCustomIDWithRedid:(NSString *)redid success:(void(^)(NSMutableArray <IDModel*> *modelArr))success failure:(void(^)(void))failure;

/// 获取展示的身份
- (void)loadDisplayIDWithRedid:(NSString *)redid success:(void(^)(IDModel *model))success failure:(void(^)(void))failure;

/// 将id为idStr的身份设置成要展示的身份
- (void)displayIDWithModel:(IDModel*)model success:(void(^)(void))success failure:(void(^)(void))failure;

/// 将id为idStr的身份删除
- (void)deleteIDWithIDstr:(NSString*)idStr success:(void(^)(void))success failure:(void(^)(void))failure;

/// 从本地数据库获取认证身份
- (nullable NSMutableArray<IDModel*>*)getAutIDModelArrFromLocal;

/// 从本地数据库获取个性身份
- (nullable NSMutableArray<IDModel*>*)getCusIDModelArrFromLocal;

/// 从本地数据库获取展示身份
- (nullable IDModel*)getDispIDModelFromLocal;

/// 单例的创建方法
+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
