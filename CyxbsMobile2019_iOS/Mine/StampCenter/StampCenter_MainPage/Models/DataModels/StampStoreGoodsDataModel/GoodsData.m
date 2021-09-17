//
//  GoodsData.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GoodsData.h"
@implementation GoodsData


+ (instancetype)GoodsDataWithDict:(NSDictionary *)dict{
    GoodsData *data = [[self alloc]init];
    [data setValuesForKeysWithDictionary:dict];
    return data;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (void)GoodsDataWithSuccess:(void (^)(NSArray * _Nonnull))success error:(void (^)(void))error{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:Stamp_Store_Main_Page method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //字典转模型
        NSArray *array = responseObject[@"data"][@"shop"];
        NSLog(@"%@",responseObject);
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:99];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GoodsData *data = [self GoodsDataWithDict:obj];
                [mArray addObject:data];
            }];
            //调用成功的回调
            if (success) {
                success(mArray.copy);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"==========================出错了");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"networkerror" object:nil];
        }];
}



@end
