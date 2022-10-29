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
@property (nonatomic, strong) UITextField *textField;

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
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.cleBtn];
    
}

#pragma mark - TT

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

#pragma mark - Setter

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(-1, 330, 281, 44)];
        _textField.centerX = self.view.width / 2;
        _textField.layer.cornerRadius = 8;
        _textField.clipsToBounds = YES;
        _textField.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
        _textField.textColor = [UIColor Light:UIColorHex(#8B8B8B) Dark:UIColorHex(#C2C2C2)];
        _textField.backgroundColor = [UIColor Light:UIColorHex(#F1F5F9CC) Dark:UIColorHex(#282828)];
        _textField.delegate = self;
        _textField.placeholder = @"请输入您的学号";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        imgView.center = view.SuperCenter;
        imgView.image = [UIImage imageNamed:@"logo.sno"];
        [view addSubview:imgView];
        _textField.leftView = view;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIButton *)cleBtn {
    if (_cleBtn == nil) {
        _cleBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, -1, 274, 51)];
        _cleBtn.centerX = self.view.width / 2;
        _cleBtn.centerY = (self.view.height + self.textField.bottom) / 2;
        [_cleBtn addGradientBlueLayer];
        _cleBtn.layer.cornerRadius = _cleBtn.height / 3;
        _cleBtn.clipsToBounds = YES;
        _cleBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:16];
        [_cleBtn setTitle:@"注  消" forState:UIControlStateNormal];
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
    [NSUserDefaults.standardUserDefaults setValue:self.textField.text forKey:UDKey.sno];
    self.textField.text = @"";
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
