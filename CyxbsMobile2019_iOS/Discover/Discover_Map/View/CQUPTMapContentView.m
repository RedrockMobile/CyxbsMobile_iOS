//
//  CQUPTMapContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapContentView.h"


@interface CQUPTMapContentView ()

@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UITextField *searchBar;
@property (nonatomic, weak) UIImageView *searchScopeImageView;
@property (nonatomic, weak) UIButton *cancelButton;

@end


@implementation CQUPTMapContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        self.backButton = backButton;
        
        UITextField *searchBar = [[UITextField alloc] init];
        searchBar.backgroundColor = [UIColor yellowColor];
        searchBar.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
        searchBar.leftViewMode = UITextFieldViewModeAlways;
        searchBar.placeholder = @"lalala";
        [self addSubview:searchBar];
        self.searchBar = searchBar;
        
//        UIImageView *searchScopeImageView = [UIImageView alloc] initWithImage:<#(nullable UIImage *)#>];
        UIImageView *searchScopeImageView = [[UIImageView alloc] init];
        searchScopeImageView.backgroundColor = [UIColor grayColor];
        [searchBar addSubview:searchScopeImageView];
        self.searchScopeImageView = searchScopeImageView;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [cancelButton setImage:[UIImage imageNamed:<#(nonnull NSString *)#>] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor grayColor];
        [self.searchBar addSubview:cancelButton];
        self.cancelButton = cancelButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUSBARHEIGHT + 15);
        make.leading.equalTo(self).offset(15);
        make.height.equalTo(@19);
        make.width.equalTo(@9);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing).offset(20);
        make.centerY.equalTo(self.backButton);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@32);
    }];
    self.searchBar.layer.cornerRadius = 16;
    
    [self.searchScopeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.searchBar).offset(12);
        make.centerY.equalTo(self.searchBar);
        make.height.width.equalTo(@15);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.searchBar).offset(-16);
        make.centerY.equalTo(self.searchBar);
        make.height.width.equalTo(@10);
    }];
}

- (void)back {
    
}

@end
