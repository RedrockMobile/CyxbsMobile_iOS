//
//  JHMenuView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 有多种风格的按钮
#import "JHMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 这个这个枚举用来扩展
typedef NS_ENUM(NSUInteger, JHMenuViewItemStyle) {
    JHMenuItemStyleDefault,
    JHMenuItemStyleLine, // 底部一根线
    JHMenuItemStyleNone, // 没有其他的变化
};

@protocol JHMenuViewDelegate <NSObject>
/// 点击方法
- (void)itemClickedIndex:(NSUInteger)index;

@end

@interface JHMenuView : UIView

@property (nonatomic, strong) UIImageView * sliderLinePart;

/// 选中的item
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, copy) NSArray <NSString *> * titles;
@property (nonatomic, assign, readonly) JHMenuViewItemStyle menuViewItemStyle;

@property (nonatomic, weak) id <JHMenuViewDelegate> delegate;

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles
                     ItemStyle:(JHMenuViewItemStyle)menuViewItemStyle;

@end

NS_ASSUME_NONNULL_END
