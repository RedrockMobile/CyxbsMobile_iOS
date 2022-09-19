//
//  LoginTextFieldView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

// 此类为登录和账密界面输入框以及输入框上面的图案与文字提示的View
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginTextFieldView : UITextField

/// 是否为登录页
@property (nonatomic, assign) bool isLoginVC;

/// 图案
@property (nonatomic, strong) UIImageView *iconImgView;

/// 键盘上面有一个toolBar，上面的提示文字，与输入框的placeholder相同
@property (nonatomic, strong) UILabel *keyboardPlaceholderLab;

/// 判断是否为登录页面，判断完后设置属性
- (void)setTextTield;
@end

NS_ASSUME_NONNULL_END
