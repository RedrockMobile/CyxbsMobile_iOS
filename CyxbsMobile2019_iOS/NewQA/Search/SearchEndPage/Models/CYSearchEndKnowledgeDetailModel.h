//
//  CYSearchEndKnowledgeDetailModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 重邮知识库详情页的model
@interface CYSearchEndKnowledgeDetailModel : NSObject
/// 标题
@property (nonatomic ,copy) NSString *titleStr;
/// 内容描述
@property (nonatomic ,copy) NSString *contentStr;
/// 来源
@property (nonatomic ,copy) NSString *sourceStr;
/// 图片的名字
@property (nonatomic ,copy) NSString *image;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
