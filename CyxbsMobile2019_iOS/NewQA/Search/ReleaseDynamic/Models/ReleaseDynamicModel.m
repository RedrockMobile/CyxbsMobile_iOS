//
//  ReleaseDynamicModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ReleaseDynamicModel.h"

@implementation ReleaseDynamicModel
- (void)sumitDynamicDataWithContent:(NSString *)content TopicID:(NSString *)topic_id ImageAry:(NSArray *)imageAry IsOriginPhoto:(BOOL)isOriginPhoto Sucess:(void (^)(void))sucess Failure:(void (^)(void))failure{
    HttpClient *client = [HttpClient defaultClient];
   
    //获取学号
    UserItem *item = [[UserItem alloc] init];
    NSString *userid = item.stuNum;
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:content forKey:@"content"];
    [param setObject:userid forKey:@"stuNum"];
    [param setObject:topic_id forKey:@"topic_id"];
    
    //如果有图片，将图片加入到参数字典中
    if (imageAry != 0) {
        NSMutableArray *imageNameAry = [NSMutableArray array];
        for (int i = 0; i < imageAry.count; i++) {
            [imageNameAry addObject:[NSString stringWithFormat:@"photo%d",i+1]];
        }

        //如果上传原图，将图片进行无损压缩
        if (isOriginPhoto == YES) {
            for (int i = 0; i < imageAry.count; i++) {
                UIImage *image = imageAry[i];
                NSData *data = UIImagePNGRepresentation(image);
                [param setObject:data forKey:imageNameAry[i]];
            }
        }else{
        //如果不上传原图，将图片进行有损压缩
            for (int i = 0; i < imageAry.count; i++) {
                UIImage *image = imageAry[i];
                NSData *data = UIImageJPEGRepresentation(image, 0.4);
                [param setObject:data forKey:imageNameAry[i]];
            }
        }
    }
    
    //网络请求
    [client requestWithPath:NEWQA_RELEASEDYNAMIC_RELEASE_API method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"发布动态成功----%@",responseObject);
        sucess();
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"发布动态失败----%@",error);
            failure();
        }];
}

- (void)getAllTopicsSucess:(void (^)(NSArray * _Nonnull))sucess{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"圈子广场请求成功------%@",responseObject);
        NSArray *dataAry = responseObject[@"data"];
        NSMutableArray *muteAry = [NSMutableArray array];
        for (NSDictionary *dic in dataAry) {
            NSString *topicName = dic[@"topic_name"];
            [muteAry addObject:topicName];
        }
        NSArray *ary = muteAry;
        sucess(ary);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"获取圈子广场失败-----%@",error);
        }];
}
@end
