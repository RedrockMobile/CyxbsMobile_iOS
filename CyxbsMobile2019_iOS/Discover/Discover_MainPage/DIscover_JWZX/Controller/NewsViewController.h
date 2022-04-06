//
//  NewsViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

/**教务新闻模块
 * 实现展示教务新闻
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JWZXNewsModel;

#pragma mark - NewsViewController

@interface NewsViewController : UIViewController

/// 当外界已经请求过一遍后，可以不再请求
/// @param model 被请求过的model
- (instancetype)initWithJWZXNewsModel:(JWZXNewsModel *)model;

@end

NS_ASSUME_NONNULL_END
