//
//  SearchPeopleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPeopleViewController.h"

#import "SearchPersonModel.h"

@interface SearchPeopleViewController () <
    UITextFieldDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

/// text view
@property (nonatomic, strong) UITextField *textField;

/// cancel btn
@property (nonatomic, strong) UIButton *cancelBtn;

/// table view
@property (nonatomic, strong) UITableView *tableview;

/// search person
@property (nonatomic, strong) SearchPersonModel *searchModel;

@end

#pragma mark - SearchPeopleViewController

@implementation SearchPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
    
    self.searchModel = [[SearchPersonModel alloc] init];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.tableview];
}

#pragma mark - Method

- (void)foucus {
    [self.textField becomeFirstResponder];
}

- (void)_request {
    
}

- (void)_cancel:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchModel.personAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - Getter

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16, StatusBarHeight(), -1, 44)];
        _textField.width = self.view.width - 2 * _textField.left - 60;
        _textField.layer.cornerRadius = 8;
        _textField.clipsToBounds = YES;
        _textField.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:14];
        _textField.textColor = [UIColor Light:UIColorHex(#8B8B8B) Dark:UIColorHex(#C2C2C2)];
        _textField.backgroundColor = [UIColor Light:UIColorHex(#F1F5F9CC) Dark:UIColorHex(#282828)];
        _textField.delegate = self;
        _textField.placeholder = @"输入内容";
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

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.textField.right + 5, self.textField.top, -1, self.textField.height)];
        _cancelBtn.width = self.view.width - _cancelBtn.left - 16;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cancelBtn;
}

- (UITableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(16, self.textField.bottom + 10, self.view.width - 2 * 16, self.view.height - self.textField.bottom - 10) style:UITableViewStylePlain];
        
    }
    return _tableview;
}

@end
