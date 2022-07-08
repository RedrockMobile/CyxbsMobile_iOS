//
//  NewQAContentScrollView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HeadViewHeight (205 * HScaleRate_SE - SCREEN_WIDTH * 0.04 * 11/15)

NS_ASSUME_NONNULL_BEGIN

@interface NewQAContentScrollView : UIScrollView

@property (nonatomic, assign) CGPoint offset;

@end

NS_ASSUME_NONNULL_END
