//
//  ReleaseDynamicModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseDynamicModel : NSObject
/// 上传发布动态的内容（原图）
/// @param content 内容文本
/// @param topic_id 标题
/// @param imageAry 图片数组
/// @param isOriginPhoto 是否支持上传原图
/// @param sucess 成功上传后的操作
/// @param failure 失败上传后的操作
- (void)sumitDynamicDataWithContent:(NSString *)content TopicID:(NSString *)topic_id ImageAry:(NSArray *)imageAry IsOriginPhoto:(BOOL)isOriginPhoto Sucess:(void(^)(void))sucess Failure:(void(^)(void))failure;

//获取所有的标题
- (void)getAllTopicsSucess:(void(^)(NSArray *topicsAry))sucess;
@end

NS_ASSUME_NONNULL_END
