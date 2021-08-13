//
//  DiscoverTodoSheetView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DiscoverTodoSheetViewDelegate <NSObject>
- (void)sheetViewSaveBtnClicked;
- (void)sheetViewCancelBtnClicked;
@end

/// 点击发现页的DiscoverTodoView的加号按钮后出来的弹窗，self是灰色的背景，
/// 内部有个属性backView是承载大部分view的白色背景
@interface DiscoverTodoSheetView : UIView

/// 代理会设置成DiscoverViewController
@property(nonatomic, weak)id <DiscoverTodoSheetViewDelegate> delegate;

/// 外界调用，调用后用动画的方式弹出
- (void)show;
@end

NS_ASSUME_NONNULL_END
