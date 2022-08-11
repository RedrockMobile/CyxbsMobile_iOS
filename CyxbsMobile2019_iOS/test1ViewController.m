//
//  test1ViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/11.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "test1ViewController.h"

@interface test1ViewController ()
@property(nonatomic,strong) UILabel *lab;
@end

@implementation test1ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.lab];
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@50);
    }];
    self.lab.text = @"2";
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(touchgButton) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = UIColor.redColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.lab.mas_bottom);
        make.width.height.equalTo(@50);
    }];
}

-(void)touchgButton{
    UIViewController *vc = [self.router controllerForRouterPath:@"test2" parameters:(NSDictionary *)self.lab.text];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)lab{
    if (!_lab) {
        _lab = [[UILabel alloc] init];
    }
    return _lab;
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"test1"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                test1ViewController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数

            NSString *str1 = [NSString stringWithFormat:@"%@",request.parameters[@"A"]];
            NSParameterAssert(str1);
            response.responseSource = str1; 
        } break;
            
        case RouterRequestController: {
            
            test1ViewController *vc = [[self alloc] init];
            vc.lab.backgroundColor = UIColor.yellowColor;
            vc.lab.text=[NSString stringWithFormat:@"%@",request.parameters];
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end
