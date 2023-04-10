//
//  EnterButton.h
//  testForLargeTitle
//
//  Created by qianqian on 2019/10/22.
//  Copyright © 2019 qianqian. All rights reserved.
//

// 此类为首页四个按钮（重邮地图，校车轨迹...）的封装
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EnterButton : UIView

@property (nonatomic, weak) UIButton *imageButton;
@property (nonatomic, weak) UILabel *label;

- (instancetype)initWithImageButton:(UIButton *)button label:(UILabel *)label;
@end

NS_ASSUME_NONNULL_END


