//
//  SearchPeopleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPeopleViewController.h"
#import "SearchPersonTableViewCell.h"

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
@property (nonatomic, strong) UITableView *tableView;

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
    [self.view addSubview:self.tableView];
}

#pragma mark - Method

- (void)foucus {
    [self.textField becomeFirstResponder];
}

- (void)_request:(NSString *)str {
    [self.searchModel
     reqestWithInfo:str
     success:^{
        [self.tableView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_cancel:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchModel.personAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchPersonTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    SearchPerson *person = self.searchModel.personAry[indexPath.row];
    cell.name = [NSString stringWithFormat:@"%@(%@)", person.name, person.gender];
    cell.sno = person.stunum;
    cell.inClass = person.classnum;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@" "]) {
        return NO;
    }
    NSString *key;
    if ([string isEqualToString:@""]) {
        key = [textField.text substringToIndex:textField.text.length - 1];
    } else {
        key = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self _request:key];
    } else {
        //优化了延迟500毫秒记录输入内容，发起请求
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(_request:) withObject:key afterDelay:0.8];
    }
    return YES;
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

- (UITableView *)_tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, self.textField.bottom + 10, self.view.width - 2 * 16, self.view.height - self.textField.bottom - 10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:SearchPersonTableViewCell.class forCellReuseIdentifier:SearchPersonTableViewCellReuseIdentifier];
    }
    return _tableView;
}

@end
