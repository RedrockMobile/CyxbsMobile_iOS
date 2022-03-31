//
//  QuestionButton.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Frame.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionButton : UIButton

/// 用于多button的标识符
@property (nonatomic) NSUInteger target;

/// 计算属性，设置标题或得到标题
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
