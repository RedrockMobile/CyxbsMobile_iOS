//
//  DiscoverADController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**DiscoverADController
 * “发现”广告位封装
 * 直接addChildViewController
 * 然后addSubview就可以了！
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DiscoverADController

@interface DiscoverADController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/// 通过直接初始化得到（必须提前确定frame）
- (instancetype)initWithViewFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
