//
//  SearchBeginVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchBeginVC.h"
#import "SearchBeiginView.h"
@interface SearchBeginVC ()<SearchTopViewDelegate,UITextFieldDelegate>
/// 上半部分视图
@property (nonatomic, strong) SearchBeiginView *searchBeginTopView;
@end

@implementation SearchBeginVC
#pragma mark- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

//进行控件布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //上半部分视图
    [self.view addSubview:self.searchBeginTopView];
    self.searchBeginTopView.frame = self.view.frame;
}

#pragma mark- delegate
//MARK:上半部分视图的代理方法以及UITextfield的代理方法
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- event response
//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark- private methods

#pragma mark- getter
- (SearchBeiginView *)searchBeginTopView{
    if (_searchBeginTopView == nil) {
        _searchBeginTopView = [[SearchBeiginView alloc] init];
        //设置顶部搜索视图的代理
        _searchBeginTopView.searchTopView.delegate = self;
    }
    return _searchBeginTopView;
}
@end
