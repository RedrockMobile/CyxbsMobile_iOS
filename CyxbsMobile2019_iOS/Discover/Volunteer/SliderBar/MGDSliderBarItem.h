//
//  MGDSliderBarItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MGDSliderBarItemDelegate;

@interface MGDSliderBarItem : UIView

@property (assign, nonatomic) BOOL selected;
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id<MGDSliderBarItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;

+ (CGFloat)widthForTitle:(NSString *)title;

@end

@protocol MGDSliderBarItemDelegate <NSObject>

- (void)sliderBarItemSelected:(MGDSliderBarItem *)item;

@end


NS_ASSUME_NONNULL_END
