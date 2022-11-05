//
//  SearchPeopleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPeopleViewController.h"

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



@end

@implementation SearchPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
