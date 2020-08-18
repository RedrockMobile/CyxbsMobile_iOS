//
//  DLWeeklSelectView.h
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WeekSelectDelegate <NSObject>

/// 某个周按钮被点后要调用的代理方法
/// @param index 被点按钮的tag
- (void)selectedWeekArrayAtIndex:(NSInteger)index;

@end

/// 周选择view的背景，全屏尺寸的view
@interface DLWeeklSelectView : UIView

/// 确定按钮，由外界addtarget
@property (nonatomic, strong) UIButton *confirmBtn;

/// 重写了set方法，对weekArray赋值，自动完成内部周选择按钮的初始化
@property (nonatomic, strong) NSArray *weekArray;

/// 某个周按钮被点后调用代理方法，
@property (nonatomic, weak) id<WeekSelectDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
