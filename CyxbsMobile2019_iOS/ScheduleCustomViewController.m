//
//  ScheduleCustomViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleCustomViewController.h"

#import "HttpTool.h"

@interface ScheduleCustomViewController ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIImageView *bkImgView;

@end

@implementation ScheduleCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bkImgView];
    [self.view addSubview:self.backBtn];
    
    [self test];
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, StatusBarHeight() + 10, 60, 18)];
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_backBtn setTitleColor:UIColorHex(#4841E2) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)bkImgView {
    if (_bkImgView == nil) {
        _bkImgView = [[UIImageView alloc] initWithFrame:self.view.SuperFrame];
        _bkImgView.image = [UIImage imageNamed:@"schedule.custom.bk"];
    }
    return _bkImgView;
}

- (void)test {
    [HttpTool.shareTool
    request:@"https://be-prod.redrock.cqupt.edu.cn/magipoke/token" type:HttpToolRequestTypePost serializer:HttpToolRequestSerializerJSON bodyParameters:@{
        @"stuNum" : @"2021215154",
        @"idNum" : @"062411"
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"%@", object);
    } failure:nil];
}

- (void)_cancel:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
