//
//  MGDSliderBar.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MGDSliderBarItemSelectedCallBack)(NSInteger index);

@interface MGDSliderBar : UIView

@property (assign, nonatomic) NSInteger itemFontSize;

@property (strong, nonatomic) UIColor *itemColor;

@property (nonatomic, copy) NSArray *itemsTitle;

@property (nonatomic, assign) NSInteger itemWidth;

- (void)sliderBarItemSelectedCallBack:(MGDSliderBarItemSelectedCallBack)callback;

- (void)selectedBarItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
