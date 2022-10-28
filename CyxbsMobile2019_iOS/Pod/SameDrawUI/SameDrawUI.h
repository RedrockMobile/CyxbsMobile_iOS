//
//  SameDrawUI.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef SameDrawUI_h
#define SameDrawUI_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const struct CyxbsEmptyImageName {
    __unsafe_unretained NSString *error404;
    __unsafe_unretained NSString *kebiao;
    __unsafe_unretained NSString *sleepy __deprecated_msg("没写");
    __unsafe_unretained NSString *openCurtain __deprecated_msg("没写");
    __unsafe_unretained NSString *emptyMessage __deprecated_msg("没写");
    __unsafe_unretained NSString *emptyList __deprecated_msg("没写");
    __unsafe_unretained NSString *checkBoard __deprecated_msg("没写");
    __unsafe_unretained NSString *toTheMoon __deprecated_msg("没写");
    __unsafe_unretained NSString *letItRot __deprecated_msg("没写");
    __unsafe_unretained NSString *haveAnyQuestion __deprecated_msg("没写");
} CyxbsEmptyImageName;

@interface UIView (SameDrawUI)

/// 添加渐变蓝色
- (void)addGradientBlueLayer;

+ (UIView *)placeholderViewWith:(void (^ _Nullable)(UIImageView *imgView, UILabel *contentLab))block;

@end

NS_ASSUME_NONNULL_END

#endif /* SameDrawUI_h */
