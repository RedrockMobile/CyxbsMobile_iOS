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

@interface UIView (SameDrawUI)

/// 添加渐变蓝色
- (void)addGradientBlueLayer;

@end

extern const struct CyxbsEmptyViewKeys {
    __unsafe_unretained NSString *traverseParentHierarchy; // boxed BOOL. default is YES.
    __unsafe_unretained NSString *pushParentBack;           // boxed BOOL. default is YES.
    __unsafe_unretained NSString *animationDuration; // boxed double, in seconds. default is 0.5.
    __unsafe_unretained NSString *parentAlpha;       // boxed float. lower is darker. default is 0.5.
    __unsafe_unretained NSString *parentScale;       // boxed double default is 0.8
    __unsafe_unretained NSString *shadowOpacity;     // default is 0.8
    __unsafe_unretained NSString *transitionStyle;     // boxed NSNumber - one of the KNSemiModalTransitionStyle values.
    __unsafe_unretained NSString *disableCancel;     // boxed BOOL. default is NO.
    __unsafe_unretained NSString *backgroundView;     // UIView, custom background.
} KNSemiModalOptionKeys;

#endif /* SameDrawUI_h */
