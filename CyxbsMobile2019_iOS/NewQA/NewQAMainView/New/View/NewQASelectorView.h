//
//  NewQASelectorView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQASelectorView : UIView

@property (nonatomic, assign) NSInteger selectedItemIndex;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, weak) UIButton *selectedButton;

@property (assign, nonatomic) CGRect leftBtnFrame;
@property (assign, nonatomic) CGRect rightBtnFrame;
@property (nonatomic, strong) UIView *tableSliderBackView;
@property (nonatomic, strong) UIImageView *sliderLinePart;
@property (nonatomic) CGFloat sliderWidth;  //标题下小滑块宽
@property (nonatomic) CGFloat sliderHeight;  //标题下小滑块高

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

@property (nonatomic, copy)  void(^buttonSelected)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
