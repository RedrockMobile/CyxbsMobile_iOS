//
//  DiscoverJWZXVC.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 暴露在发现页的教务在线新闻
@interface DiscoverJWZXVC : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/// 通过确定top和height（left应为0，width应为父视图width）
/// @param frame 主视图的frame
- (instancetype)initWithViewFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
