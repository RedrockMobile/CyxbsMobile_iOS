//
//  FastLoginViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/25.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "FastLoginViewController.h"

#import "ScheduleNeedsSupport.h"

#import "SchedulePresenter.h"

#import "ScheduleWidgetCache.h"

@interface FastLoginViewController () <UITextFieldDelegate>

/// <#description#>
@property (nonatomic, strong) UITextField *snoField;

/// <#description#>
@property (nonatomic, strong) UITextField *otherField;

/// <#description#>
@property (nonatomic, strong) UIButton *cleBtn;

@property (nonatomic, strong) UITextField *widgetField;

@end

@implementation FastLoginViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _drawTabbar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
    
    [self.view addSubview:self.snoField];
    [self.view addSubview:self.otherField];
    [self.view addSubview:self.cleBtn];
//    [self.view addSubview:self.widgetField];
}

#pragma mark - TT

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Setter

- (UITextField *)snoField {
    if (_snoField == nil) {
        _snoField = [self _kindFieldWithPlaceholder:@"请输入您的学号" imgName:@"logo.sno"];
        _snoField.frame = CGRectMake(-1, StatusBarHeight() + 100, 281, 44);
        _snoField.centerX = self.view.width / 2;
    }
    return _snoField;
}

- (UITextField *)otherField {
    if (_otherField == nil) {
        _otherField = [self _kindFieldWithPlaceholder:@"请输入对方的学号" imgName:@"logo.reset"];
        _otherField.frame = CGRectMake(-1, self.snoField.bottom + 22, 281, 44);
        _otherField.centerX = self.view.width / 2;
    }
    return _otherField;
}

- (UITextField *)widgetField {
    if (_widgetField == nil) {
        _widgetField = [self _kindFieldWithPlaceholder:@"输入小组件展示周数" imgName:@"more"];
        _widgetField.frame = CGRectMake(-1, self.otherField.bottom + 22, 281, 44);
        _widgetField.centerX = self.view.width / 2;
        _widgetField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    }
    return _widgetField;
}

- (UITextField *)_kindFieldWithPlaceholder:(NSString *)placeholder imgName:(NSString *)imgName {
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.cornerRadius = 8;
    textField.clipsToBounds = YES;
    textField.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
    textField.textColor = [UIColor Light:UIColorHex(#8B8B8B) Dark:UIColorHex(#C2C2C2)];
    textField.backgroundColor = [UIColor Light:UIColorHex(#F1F5F9CC) Dark:UIColorHex(#282828)];
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
    imgView.center = view.SuperCenter;
    imgView.image = [UIImage imageNamed:imgName];
    [view addSubview:imgView];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (UIButton *)cleBtn {
    if (_cleBtn == nil) {
        _cleBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, -1, 274, 51)];
        _cleBtn.centerX = self.view.width / 2;
        _cleBtn.centerY = (self.view.height + self.snoField.bottom) / 2;
        [_cleBtn addGradientBlueLayer];
        _cleBtn.layer.cornerRadius = _cleBtn.height / 3;
        _cleBtn.clipsToBounds = YES;
        _cleBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:16];
        [_cleBtn setTitle:@"开  始" forState:UIControlStateNormal];
        [_cleBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_cleBtn bringSubviewToFront:_cleBtn.titleLabel];
        [_cleBtn addTarget:self action:@selector(_cletap:)
          forControlEvents:UIControlEventTouchUpInside];
        [_cleBtn addTarget:self action:@selector(_outside:) forControlEvents:UIControlEventTouchDragOutside];
    }
    return _cleBtn;
}

#pragma mark - private

- (void)_cletap:(UIButton *)btn {
    NSString *sno = self.snoField.text.copy;
    ScheduleIdentifier *mainID = [ScheduleIdentifier identifierWithSno:sno type:ScheduleModelRequestStudent];
    if (self.otherField.text && ![self.otherField.text isEqualToString:@""]) {
        NSString *otherSno = self.otherField.text.copy;
        ScheduleIdentifier *otherID = [ScheduleIdentifier identifierWithSno:otherSno type:ScheduleModelRequestStudent];
        
        [self.presenter setWithMainKey:mainID otherKey:otherID];
    } else {
        [self.presenter setWithMainKey:mainID];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerTapBegin:)]) {
        [self.delegate viewControllerTapBegin:self];
    }
    
//    if (self.widgetField.text && ![self.widgetField.text isEqualToString:@""]) {
//        [self.presenter setWidgetSection:self.widgetField.text.integerValue];
//    }
}

- (void)_outside:(UIButton *)btn {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:UDKey.isXXHB];
    self.presenter.awakeable = YES;
}





- (void)_drawTabbar {
    UIImage *selectImg = [[[UIImage imageNamed:@"more"] imageByResizeToSize:CGSizeMake(20, 20) contentMode:UIViewContentModeScaleAspectFit] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectImg = [[[UIImage imageNamed:@"more"] imageByResizeToSize:CGSizeMake(20, 20) contentMode:UIViewContentModeScaleAspectFit] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"登录" image:unselectImg selectedImage:selectImg];
    [self.tabBarItem setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Regular size:10],
        NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#2923D2) Dark:UIColorHex(#465FFF)]
    } forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Regular size:10],
        NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#AABCD8) Dark:UIColorHex(#8C8C8C)]
    } forState:UIControlStateNormal];
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text || ![textField.text isEqualToString:@""]) {
        return;
    }
}

@end
