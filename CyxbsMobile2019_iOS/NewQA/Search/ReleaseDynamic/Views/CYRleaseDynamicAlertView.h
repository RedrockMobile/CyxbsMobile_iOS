//
//  CYRleaseDynamicAlertView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CYRleaseDynamicAlertViewDelegate <NSObject>

/// 保存草稿
- (void)saveDrafts;

/// 不保存草稿
- (void)notSaveDrafts;

/// 取消
- (void)dismisAlertViews;

@end
/// 在发布动态页有内容时出现，保存草稿，或者不保存，或者取消
@interface CYRleaseDynamicAlertView : UIView
@property (nonatomic, weak) id<CYRleaseDynamicAlertViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
