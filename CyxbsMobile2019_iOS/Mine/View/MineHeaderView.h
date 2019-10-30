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

@property (nonatomic, weak) UILabel *questionsNumberLabel;

@property (nonatomic, weak) UILabel *answerNumberLabel;

@property (nonatomic, weak) UILabel *responseNumberLabel;

//@property (nonatomic, weak) UILabel *

@end

NS_ASSUME_NONNULL_END
