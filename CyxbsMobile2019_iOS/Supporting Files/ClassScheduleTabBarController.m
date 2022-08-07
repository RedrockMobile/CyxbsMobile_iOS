//
//  ClassScheduleTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/1.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassScheduleTabBarController.h"

@interface ClassScheduleTabBarController () <
    UITabBarControllerDelegate
>

@end

@implementation ClassScheduleTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewControllers =
        @[self.DiscoverVC,
          self.QAVC,
          self.MineVC];
        
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tabBarSytle];
}

- (void)tabBarSytle {
    self.tabBar.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
    
    self.tabBar.tintColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#465FFF" alpha:1]];
}

#pragma mark - <UITabBarControllerDelegate>

//- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    
//}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"SchoolTabBarController"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                ClassScheduleTabBarController *vc = [[self alloc] init];
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
            
            ClassScheduleTabBarController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}



#pragma mark - Getter

- (UIViewController *)DiscoverVC {
    return [[UINavigationController alloc] initWithRootViewController:[self.router controllerForRouterPath:@"DiscoverVC"]];
}

- (UIViewController *)QAVC {
    return [[UINavigationController alloc] initWithRootViewController:[self.router controllerForRouterPath:@"QAVC"]];
}

- (UIViewController *)MineVC {
    return [[UINavigationController alloc] initWithRootViewController:[self.router controllerForRouterPath:@"MineVC"]];
}

@end
