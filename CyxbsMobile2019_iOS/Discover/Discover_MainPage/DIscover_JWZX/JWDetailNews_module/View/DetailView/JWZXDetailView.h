//
//  JWZXDetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWZXDetailView : UIView

/// 加载视图
/// @param date 日期
/// @param title 标题
/// @param detail 细节
- (void)loadViewWithDate:(NSString *)date
                   title:(NSString *)title
                  detail:(NSString *)detail;

@end

NS_ASSUME_NONNULL_END
