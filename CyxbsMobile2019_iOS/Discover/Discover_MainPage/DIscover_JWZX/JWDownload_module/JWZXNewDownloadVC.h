//
//  JWZXNewDownloadVC.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWZXDetailNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWZXNewDownloadVC : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/// 根据细节模型弹出下载选项
/// @param model 一个Detail模型
- (instancetype)initWithDetailNewsModel:(JWZXDetailNewsModel *)model;

@end

NS_ASSUME_NONNULL_END
