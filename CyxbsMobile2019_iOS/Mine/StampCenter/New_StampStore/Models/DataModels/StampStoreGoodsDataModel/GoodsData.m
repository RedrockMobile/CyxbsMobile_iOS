//
//  GoodsData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GoodsData.h"
#import "ZWTMacro.h"
@implementation GoodsData


+ (instancetype)GoodsDataWithDict:(NSDictionary *)dict{
    GoodsData *data = [[self alloc]init];
    [data setValuesForKeysWithDictionary:dict];
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (void)GoodsDataWithSuccess:(void (^)(NSArray * _Nonnull))success error:(void (^)(void))error{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
    [manager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //字典转模型
        NSArray *array = responseObject[@"data"][@"shop"];
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:99];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GoodsData *data = [self GoodsDataWithDict:obj];
                [mArray addObject:data];
            }];
            //调用成功的回调
            if (success) {
                success(mArray.copy);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull er) {
            NSLog(@"==========================出错了");
        }];
}



@end
