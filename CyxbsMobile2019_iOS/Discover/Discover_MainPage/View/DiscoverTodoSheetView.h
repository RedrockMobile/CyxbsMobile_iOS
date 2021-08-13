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

/// 点击发现页的DiscoverTodoView的加号按钮后出来的弹窗
@interface DiscoverTodoSheetView : UIView
@property(nonatomic, weak)id <DiscoverTodoSheetViewDelegate> delegate;
- (void)show;
@end

NS_ASSUME_NONNULL_END
