//
//  TODOMainViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

//controllers
#import "TODOMainViewController.h"

//Model

//Views
#import "ToDoMainBarView.h"



@interface TODOMainViewController ()<ToDoMainBarViewDelegate>
/// 顶层的View
@property (nonatomic, strong) ToDoMainBarView *barView;
@end

@implementation TODOMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

#pragma mark- private methonds
- (void)setFrame{
    //顶部的bar
    [self.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.0637));
    }];
}

#pragma mark- Delegate
//MARK:顶部bar的代理方法
/// 返回到上一界面
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 添加待办事项
- (void)addMatter{
    NSLog(@"已经添加待办事项");
}


#pragma mark- Getter
- (ToDoMainBarView *)barView{
    if (!_barView) {
        _barView = [[ToDoMainBarView alloc] initWithFrame:CGRectZero];
        _barView.delegate = self;
    }
    return _barView;
}
@end
