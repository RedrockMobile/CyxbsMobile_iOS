//
//  JWZXNewsAnnexModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 教务在线单个新闻单个附件信息
@interface JWZXNewsAnnexModel : NSObject

/// 附件对应的ID
@property (nonatomic, copy) NSString *annexID;

/// 日期以及下载数
@property (nonatomic, copy) NSString *name;

/// 根据字典创建
/// @param dic 传入字典
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
