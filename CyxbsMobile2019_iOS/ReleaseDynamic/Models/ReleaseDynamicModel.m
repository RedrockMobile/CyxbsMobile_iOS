//
//  ReleaseDynamicModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ReleaseDynamicModel.h"
//tool
#import "UIImage+Helper.h"
#import "NSDate+Timestamp.h"
@implementation ReleaseDynamicModel
- (void)sumitDynamicDataWithContent:(NSString *)content TopicID:(NSString *)topic_id ImageAry:(NSArray *)imageAry IsOriginPhoto:(BOOL)isOriginPhoto Sucess:(void (^)(void))sucess Failure:(void (^)(void))failure{
   
    //获取学号
    UserItem *item = [[UserItem alloc] init];
    NSString *userid = item.stuNum;
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:content forKey:@"content"];
    [param setObject:userid forKey:@"stuNum"];
    [param setObject:topic_id forKey:@"topic_id"];
    
    
    HttpClient *client = [HttpClient defaultClient];
  
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token]  forHTTPHeaderField:@"authorization"];
    
    [client.httpSessionManager POST:NEWQA_RELEASEDYNAMIC_RELEASE_API parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSMutableArray *imageNames = [NSMutableArray array];
               for (int i = 0; i < imageAry.count; i++)  {
                   [imageNames addObject:[NSString stringWithFormat:@"photo%d",i+1]];
               }
                   for (int i = 0; i < imageAry.count; i++) {
                       UIImage *image = imageAry[i];
                       UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
                       NSData *data = UIImageJPEGRepresentation(image1, 0.8);
                       NSString *fileName = [NSString stringWithFormat:@"%ld.jpeg", [NSDate nowTimestamp]];
                       [formData appendPartWithFileData:data name:imageNames[i] fileName:fileName mimeType:@"image/jpeg"];
                   }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            sucess();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"-----%@",error);
               if (error.code == -1001) {
                   sucess();
               }else{
                   failure();
               }
        }];
}

- (void)getAllTopicsSucess:(void (^)(NSArray * _Nonnull))sucess{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:NEW_QA_TOPICGROUP method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"圈子广场请求成功------%@",responseObject);
        NSArray *dataAry = responseObject[@"data"];
        NSMutableArray *muteAry = [NSMutableArray array];
        for (NSDictionary *dic in dataAry) {
            NSString *topicName = dic[@"topic_name"];
            [muteAry addObject:topicName];
        }
        NSArray *ary = muteAry;
        sucess(ary);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"获取圈子广场失败-----%@",error);
        }];
}
@end
