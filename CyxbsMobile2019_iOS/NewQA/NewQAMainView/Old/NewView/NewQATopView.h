//
//  NewQATopView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQATopView : UIView

@property (nonatomic, strong) UIImageView *backImageView;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic, getter=getSelectedItemIndex) NSInteger selectedItemIndex;
@property (assign, nonatomic) CGRect leftBtnFrame;
@property (assign, nonatomic) CGRect rightBtnFrame;
@property (nonatomic, strong) UIView *tableSliderBackView;
@property (nonatomic, strong) UIImageView *sliderLinePart;
@property (nonatomic) CGFloat sliderWidth;  //标题下小滑块宽
@property (nonatomic) CGFloat sliderHeight;  //标题下小滑块高

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

@end

NS_ASSUME_NONNULL_END
