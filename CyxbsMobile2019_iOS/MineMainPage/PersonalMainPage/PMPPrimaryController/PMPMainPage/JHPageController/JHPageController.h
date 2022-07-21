//
//  JHPageController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 参照WMPageController写的页面控制器
 */
@interface JHPageController : UIViewController

/// 各个控制器的标题
@property (nonatomic, copy) NSArray <NSString *> * titles;
/// 子控制器
@property (nonatomic, copy) NSArray <UIViewController *> * controllers;
/**
 *  导航栏高度
 *  The menu view's height
 *  default is 56
 */
@property (nonatomic, assign) CGFloat menuHeight;

/// 构造方法
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles
                   Controllers:(NSArray *)controllers;

@end

NS_ASSUME_NONNULL_END
