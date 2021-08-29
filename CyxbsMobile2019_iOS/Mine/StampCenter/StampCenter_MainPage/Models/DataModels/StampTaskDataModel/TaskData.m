//
//  StampTaskData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TaskData.h"
#import "ZWTMacro.h"
@implementation TaskData

@dynamic description;

+ (instancetype)TaskDataWithDict:(NSDictionary *)dict{
    TaskData *data = [self new];
    [data setValuesForKeysWithDictionary:dict];
    return data;
}

+ (void)TaskDataWithSuccess:(void (^)(NSArray * _Nonnull))success error:(void (^)(void))error{
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //字典转模型
        NSArray *array = responseObject[@"data"][@"task"];
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:99];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TaskData *data = [self TaskDataWithDict:obj];
                [mArray addObject:data];
            }];
            //调用成功的回调
            if (success) {
                success(mArray.copy);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"==========================出错了");
        }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}


@end
