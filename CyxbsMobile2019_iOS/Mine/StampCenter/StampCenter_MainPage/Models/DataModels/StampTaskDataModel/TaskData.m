//
//  StampTaskData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TaskData.h"
@implementation TaskData

@dynamic description;

+ (instancetype)TaskDataWithDict:(NSDictionary *)dict{
    TaskData *data = [self new];
    [data setValuesForKeysWithDictionary:dict];
    return data;
}

+ (void)TaskDataWithSuccess:(void (^)(NSArray * _Nonnull))success error:(void (^)(void))error{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:Stamp_Store_Main_Page method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkerror" object:nil];
                }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}

@end
