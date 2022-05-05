//
//  MessageDetailVC.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailVC : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/// 根据URL加载页面
/// @param url 传入url
- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
