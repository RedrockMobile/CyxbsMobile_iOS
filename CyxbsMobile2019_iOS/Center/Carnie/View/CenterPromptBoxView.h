//
//  CenterPromptBoxView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

// 此类为邮乐园顶部的提示“来到邮乐园的第几天“的提示框
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CenterPromptBoxView : UIView

/// 名字文本
@property (nonatomic, strong) UILabel *nameLab;

/// 天数文本
@property (nonatomic, strong) UILabel *daysLab;

/// 头像
@property (nonatomic, strong) UIImageView *avatarImgView;

/// 背景图片
@property (nonatomic, strong) UIImageView *backgroundImgView;

///天数
-(void)setNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
