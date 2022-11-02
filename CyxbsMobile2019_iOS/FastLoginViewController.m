//
//  FastLoginViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/25.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "FastLoginViewController.h"

#import "SameDrawUI.h"

@interface FastLoginViewController () <UITextFieldDelegate>

/// <#description#>
@property (nonatomic, strong) UITextField *snoField;

/// <#description#>
@property (nonatomic, strong) UITextField *otherField;

/// <#description#>
@property (nonatomic, strong) UIButton *cleBtn;

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
//    [self.view addSubview:self.otherField];
    [self.view addSubview:self.cleBtn];
    
}

#pragma mark - TT

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.snoField resignFirstResponder];
}

#pragma mark - Setter

- (UITextField *)snoField {
    if (_snoField == nil) {
        _snoField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 330, 281, 44)];
        _snoField.centerX = self.view.width / 2;
        _snoField.layer.cornerRadius = 8;
        _snoField.clipsToBounds = YES;
        _snoField.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
        _snoField.textColor = [UIColor Light:UIColorHex(#8B8B8B) Dark:UIColorHex(#C2C2C2)];
        _snoField.backgroundColor = [UIColor Light:UIColorHex(#F1F5F9CC) Dark:UIColorHex(#282828)];
        _snoField.delegate = self;
        _snoField.placeholder = @"请输入您的学号";
        _snoField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        imgView.center = view.SuperCenter;
        imgView.image = [UIImage imageNamed:@"logo.sno"];
        [view addSubview:imgView];
        _snoField.leftView = view;
        _snoField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _snoField;
}

- (UITextField *)otherField {
    if (_otherField == nil) {
        _otherField = [[UITextField alloc] initWithFrame:CGRectMake(-1, self.snoField.bottom + 22, 281, 44)];
        _otherField.centerX = self.view.width / 2;
        _otherField.layer.cornerRadius = 8;
        _otherField.clipsToBounds = YES;
        _otherField.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
        _otherField.textColor = [UIColor Light:UIColorHex(#8B8B8B) Dark:UIColorHex(#C2C2C2)];
        _otherField.backgroundColor = [UIColor Light:UIColorHex(#F1F5F9CC) Dark:UIColorHex(#282828)];
        _otherField.delegate = self;
        _otherField.placeholder = @"请输入对方的学号";
        _otherField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        imgView.center = view.SuperCenter;
        imgView.image = [UIImage imageNamed:@"logo.reset"];
        [view addSubview:imgView];
        _otherField.leftView = view;
        _otherField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _otherField;
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
        [_cleBtn setTitle:@"注  销" forState:UIControlStateNormal];
        [_cleBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_cleBtn bringSubviewToFront:_cleBtn.titleLabel];
        [_cleBtn addTarget:self action:@selector(_cletap:)
          forControlEvents:UIControlEventTouchUpInside];
        [_cleBtn addTarget:self action:@selector(_outside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cleBtn;
}

#pragma mark - private

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

- (void)_cletap:(UIButton *)btn {
    if (!self.otherField.text && ![self.otherField.text isEqualToString:@""]) {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:UDKey.isDefineMuti];
    } else {
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:UDKey.isDefineMuti];
    }
    [NSUserDefaults.standardUserDefaults setValue:self.snoField.text forKey:UDKey.sno];
    [NSUserDefaults.standardUserDefaults setValue:self.otherField.text forKey:UDKey.otherSno];
    self.snoField.text = @"";
    self.otherField.text = @"";
}

- (void)_outside:(UIButton *)btn {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:UDKey.isXXHB];
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text || ![textField.text isEqualToString:@""]) {
        return;
    }
}

@end
