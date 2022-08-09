//
//  BaseTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassTabBarController.h"
#import "ClassTabBar.h"

@interface ClassTabBarController ()

@end

@implementation ClassTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValue:[[ClassTabBar alloc] init] forKey:@"tabBar"];
    
//    if (@available(iOS 15.0, *)) {
//        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
////        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//        appearance.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
//        self.tabBar.scrollEdgeAppearance = appearance;
//        self.tabBar.standardAppearance = appearance;
//    }
    
    [self addObserver:self forKeyPath:@"tabBar.hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"tabBar.hidden" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classTabBarHasHidden" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classTabBarHasDisplayed" object:nil];
    }
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"ClassTabBarController"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                ClassTabBarController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterResponseWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            ClassTabBarController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}



@end
