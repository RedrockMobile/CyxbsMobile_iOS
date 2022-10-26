//
//  FastLoginViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/25.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "FastLoginViewController.h"

@interface FastLoginViewController () <UITextFieldDelegate>

/// <#description#>
@property (nonatomic, strong) UITextField *textField;

@end

@implementation FastLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
    
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(-1, -1, 200, 48)];
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [NSUserDefaults.standardUserDefaults setValue:textField.text forKey:UDKey.sno];
}

@end
