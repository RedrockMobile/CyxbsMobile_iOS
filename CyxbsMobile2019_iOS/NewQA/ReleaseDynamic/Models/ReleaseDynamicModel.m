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
- (void)sumitDynamicDataWithContent:(NSString *)content TopicID:(NSString *)topic_id ImageAry:(NSArray *)imageAry IsOriginPhoto:(BOOL)isOriginPhoto Success:(void (^)(void))success Failure:(void (^)(void))failure{
   
    //获取学号
    UserItem *item = [[UserItem alloc] init];
    NSString *userid = item.stuNum;
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:content forKey:@"content"];
    [param setObject:userid forKey:@"stuNum"];
    [param setObject:topic_id forKey:@"topic_id"];
    
    [HttpTool.shareTool
     form:NewQA_POST_releaseDynamicRelease_API
     type:HttpToolRequestTypePost
     parameters:param
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        NSMutableArray *imageNames = [NSMutableArray array];
        for (int i = 0; i < imageAry.count; i++)  {
            [imageNames addObject:[NSString stringWithFormat:@"photo%d",i+1]];
        }
        for (int i = 0; i < imageAry.count; i++) {
            UIImage *image = imageAry[i];
            UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
            NSData *data = UIImageJPEGRepresentation(image1, 0.8);
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpeg", [NSDate nowTimestamp]];
            [body appendPartWithFileData:data name:imageNames[i] fileName:fileName mimeType:@"image/jpeg"];
        }
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
    
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
//    [client.httpSessionManager POST:NewQA_POST_releaseDynamicRelease_API parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSMutableArray *imageNames = [NSMutableArray array];
//        for (int i = 0; i < imageAry.count; i++)  {
//            [imageNames addObject:[NSString stringWithFormat:@"photo%d",i+1]];
//        }
//        for (int i = 0; i < imageAry.count; i++) {
//            UIImage *image = imageAry[i];
//            UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
//            NSData *data = UIImageJPEGRepresentation(image1, 0.8);
//            NSString *fileName = [NSString stringWithFormat:@"%ld.jpeg", [NSDate nowTimestamp]];
//            [formData appendPartWithFileData:data name:imageNames[i] fileName:fileName mimeType:@"image/jpeg"];
//        }
//        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            success();
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (error.code == -1001) {
//                success();
//            }else{
//                failure();
//            }
//        }];
}

- (void)getAllTopicsSuccess:(void (^)(NSArray * _Nonnull))success {
    
    [HttpTool.shareTool
     request:NewQA_POST_QATopicGroup_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//          NSLog(@"圈子广场请求成功------%@",responseObject);
        NSArray *dataAry = object[@"data"];
        NSMutableArray *muteAry = [NSMutableArray array];
        for (NSDictionary *dic in dataAry) {
            NSString *topicName = dic[@"topic_name"];
            [muteAry addObject:topicName];
        }
        NSArray *ary = muteAry;
        if (success) {
            success(ary);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
    
//    HttpClient *client = [HttpClient defaultClient];
//    [client requestWithPath:NewQA_POST_QATopicGroup_API method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
////        NSLog(@"圈子广场请求成功------%@",responseObject);
//        NSArray *dataAry = responseObject[@"data"];
//        NSMutableArray *muteAry = [NSMutableArray array];
//        for (NSDictionary *dic in dataAry) {
//            NSString *topicName = dic[@"topic_name"];
//            [muteAry addObject:topicName];
//        }
//        NSArray *ary = muteAry;
//        success(ary);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
////            NSLog(@"获取圈子广场失败-----%@",error);
//        }];
}
@end
