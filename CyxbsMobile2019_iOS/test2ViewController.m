//
//  test2ViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/11.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "test2ViewController.h"

@interface test2ViewController ()
@property(nonatomic,strong) UILabel *lab;
@end

@implementation test2ViewController

-  (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.lab];
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@50);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = UIColor.redColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.lab.mas_bottom);
        make.width.height.equalTo(@50);
    }];
}

- (UILabel *)lab{
    if (!_lab) {
        _lab = [[UILabel alloc] init];
    }
    return _lab;
}

//返回的方法
- (void) back {
    [RisingRouter.router sourceForRouterPath:@"test1" parameters:@{@"A":@"3"}];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"test2"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
            
        case RouterRequestPush: {
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            if (nav) {
                test2ViewController *vc = [[self alloc] init];
                response.responseController = vc;
                [nav pushViewController:vc animated:YES];
            } else {
                response.errorCode = RouterWithoutNavagation;
            }
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            test2ViewController *vc = [[self alloc] init];
            vc.lab.backgroundColor = UIColor.greenColor;
            vc.lab.text=[NSString stringWithFormat:@"%@",request.parameters];
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end
