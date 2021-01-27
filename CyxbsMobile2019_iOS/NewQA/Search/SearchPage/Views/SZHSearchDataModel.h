//
//  SZHSearchDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**用来获取热门搜索相关的数据内容*/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZHSearchDataModel : NSObject
/// 获取热搜词汇
/// @param progress 获取到热搜词组后进行的代码操作
- (void)getHotArayWithProgress:(void (^)(NSArray *ary))progress;
@end

NS_ASSUME_NONNULL_END
