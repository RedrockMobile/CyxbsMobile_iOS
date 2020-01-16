//
//  LQButton.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQButton : UIButton
@property BOOL isLight;//标记这个按钮是否被点亮
- (void) choose;
@end

NS_ASSUME_NONNULL_END

