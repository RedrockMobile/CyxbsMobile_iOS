//
//  MineHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : UIView

/// 头像ImageVIew
@property (nonatomic, weak) UIImageView *headerImageView;

/// 昵称Label
@property (nonatomic, weak) UILabel *nicknameLabel;

/// 个性签名Label
@property (nonatomic, weak) UILabel *introductionLabel;

/// 编辑按钮
@property (nonatomic, weak) UIButton *editButton;

/// 签到天数Label
@property (nonatomic, weak) UILabel *signinDaysLabel;

/// 签到按钮
@property (nonatomic, weak) UIButton *signinButton;

/// 提问数量Label
@property (nonatomic, weak) UILabel *questionsNumberLabel;

/// 回答数量Label
@property (nonatomic, weak) UILabel *answerNumberLabel;

/// 收到的回复数量Label
@property (nonatomic, weak) UILabel *responseNumberLabel;

/// 获赞数量Label
@property (nonatomic, weak) UILabel *praiseNumberLabel;

@end

NS_ASSUME_NONNULL_END
