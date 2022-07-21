//
//  EditMyInfoContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineEditTextField.h"
#import "PMPPickerView.h"
#import "PMPDatePicker.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditMyInfoContentViewDelegate <NSObject>

- (void)saveButtonClicked:(UIButton *)sender;
- (void)backButtonClicked:(UIButton *)sender;
- (void)headerImageTapped:(UIImageView *)sender;
- (void)showUserInformationIntroduction:(UIButton *)sender;
- (void)slideToDismiss:(UIPanGestureRecognizer *)sender;
@end

@interface EditMyInfoContentView : UIView

@property (nonatomic, weak) id<EditMyInfoContentViewDelegate> delegate;

@property (nonatomic, weak) UIView *gestureView;

@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIImageView *headerImageView;

/// 编辑昵称的TextField
@property (nonatomic, weak) MineEditTextField *nicknameTextField;

/// 编辑个性签名的TextField
@property (nonatomic, weak) MineEditTextField *introductionTextField;

/// 编辑QQ的TextField
@property (nonatomic, weak) MineEditTextField *genderTextField;

/// 编辑手机号码的TextField
@property (nonatomic, weak) MineEditTextField *birthdayTextField;

/// 编辑QQ的TextField
@property (nonatomic, weak) MineEditTextField *QQTextField;

/// 编辑手机号码的TextField
@property (nonatomic, weak) MineEditTextField *phoneNumberTextField;
@property (nonatomic, weak) UILabel *myAcademyLabel;
@property (nonatomic, weak) UIButton *saveButton;

@end

NS_ASSUME_NONNULL_END
