//
//  ArticleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/2.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainPageModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ArticleModelDelegate <MainPageModelDelegate>
- (void)deleteArticleSuccess;
- (void)deleteArticleFailure;
@end

/// 获取动态、删除动态用的model
@interface ArticleModel : MainPageModel
@property(nonatomic,weak)id <ArticleModelDelegate> delegate;

/// 删除动态用
/// @param ID 动态ID
- (void)deleteArticleWithID:(NSString*)ID;
@end

NS_ASSUME_NONNULL_END
