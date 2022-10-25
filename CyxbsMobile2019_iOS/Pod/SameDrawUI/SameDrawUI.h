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

extern const struct CyxbsEmptyImageName {
    __unsafe_unretained NSString *error404;
    __unsafe_unretained NSString *kebiao;
    __unsafe_unretained NSString *sleepy;
    __unsafe_unretained NSString *openCurtain;
    __unsafe_unretained NSString *emptyMessage;
    __unsafe_unretained NSString *emptyList;
    __unsafe_unretained NSString *checkBoard;
    __unsafe_unretained NSString *toTheMoon;
    __unsafe_unretained NSString *letItRot;
    __unsafe_unretained NSString *haveAnyQuestion;
} CyxbsEmptyImageName;

@interface UIView (SameDrawUI)

/// 添加渐变蓝色
- (void)addGradientBlueLayer;

/// 创建一个空白占位页
/// - Parameters:
///   - CyxbsEmptyImageName: 是上面CyxbsEmptyImageName的一种
///   - content: 描述信息，会自动换行（或手动\n）
+ (instancetype)viewWithEmptyholderImageName:(NSString *)CyxbsEmptyImageName content:(NSString *)content;

@end

#endif /* SameDrawUI_h */
