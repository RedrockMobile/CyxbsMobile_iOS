//
//  MineAboutController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/4.
//  Copyright © 2020 Redrock. All rights reserved.
//关于我们页面 - 主控制器

#import "MineAboutController.h"
#import "MineAboutContentView.h"
#import "IntroductionController.h"
#import <AFNetworking.h>

@interface MineAboutController () <MineAboutContentViewDelegate>

@end

@implementation MineAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (@available(iOS 13.0, *)) {
//        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        // Fallback on earlier versions
    }
    
    MineAboutContentView *contentView = [[MineAboutContentView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - contentView代理
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedIntroduction {
    IntroductionController *introductionVC = [[IntroductionController alloc] init];
    [self presentViewController:introductionVC animated:YES completion:nil];
}

- (void)selectedProductWebsite {
    URLController * controller = [[URLController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.toUrl = @"https://app.redrock.team/#/";
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)selectedUpdateCheck {
    [self p_versionUpdateButtonAction];

}

- (NSComparisonResult)compareSystemVersion:(NSString *)currentVersion toVersion:(NSString *)targetVersion {
    NSArray *currentVersionArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *targetVersionArr = [targetVersion componentsSeparatedByString:@"."];
    
    NSInteger pos = 0;
    
    while ([currentVersionArr count] > pos || [targetVersionArr count] > pos) {
        NSInteger v1 = [currentVersionArr count] > pos ? [[currentVersionArr objectAtIndex:pos] integerValue] : 0;
        NSInteger v2 = [targetVersionArr count] > pos ? [[targetVersionArr objectAtIndex:pos] integerValue] : 0;
        if (v1 < v2) {
            return NSOrderedAscending;
        }
        else if (v1 > v2) {
            return NSOrderedDescending;
        }
        pos++;
    }
    
    return NSOrderedSame;
}


- (void)p_versionUpdateButtonAction  {
    
    //获取当前发布的版本的Version
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //获取Store上的掌邮的版本id
    [[HttpClient defaultClient] requestWithPath:@"http://itunes.apple.com/cn/lookup?id=974026615" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = array[0];
        NSString *appstoreVersion = dict[@"version"];
        
        //请求成功，判断版本大小,如果App Store版本大于本机版本，提示更新
        NSComparisonResult result = [localVersion compare:appstoreVersion];
        
        if (result == NSOrderedAscending) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont fontWithName:PingFangSCSemibold size:17];
                    hud.detailsLabelFont = [UIFont fontWithName:PingFangSCLight size:14];
                    hud.detailsLabelText = [NSString stringWithFormat:@" %@新版本已上线 \n %@ ",dict[@"version"],dict[@"releaseNotes"]];
                    hud.labelText = @"请去 App Store 更新版本哦～";
                    [hud hide:YES afterDelay:1];
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont fontWithName:PingFangSCSemibold size:17];
                    hud.labelText = @"已经是最新版本";
                    [hud hide:YES afterDelay:1];
            }
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    
}


- (void)getAppStoreVersionInfoWithResponseBlock:(void (^)(NSDictionary *, NSError *))responseBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    
    [manager GET:@"https://itunes.apple.com/cn/lookup?id=974026615" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *dataArray = responseObject[@"results"];
        if (dataArray.count != 0) {// 先判断返回的数据是否为空
            NSDictionary *dict = dataArray.firstObject;
            responseBlock(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        responseBlock(nil, error);
    }];
}


@end
