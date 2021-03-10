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

@interface ArticleModel : MainPageModel
@property(nonatomic,weak)id <ArticleModelDelegate> delegate;
- (void)deleteArticleWithID:(NSString*)ID;
@end

NS_ASSUME_NONNULL_END
