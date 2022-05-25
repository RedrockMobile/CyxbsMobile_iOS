//
//  JWZXDetailNewsTopView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SSRTopBarBaseView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - JWZXDetailNewsTopView

@interface JWZXDetailNewsTopView : SSRTopBarBaseView

/// 是否有附件，默认没有（不显示）
@property (nonatomic) BOOL haveFiled;

/// 单击下载附件的行为
/// @param target 应该为控制器（可以为View）
/// @param action 应该为跳转控制器（可以为直接跳转应用程序）
- (void)addDonwloadButtonTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
