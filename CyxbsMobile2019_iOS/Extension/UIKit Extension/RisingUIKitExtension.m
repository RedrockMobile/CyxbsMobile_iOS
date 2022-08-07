//
//  RisingUIKitExtension.m
//  Rising
//
//  Created by SSR on 2022/7/11.
//

#import "RisingUIKitExtension.h"

@implementation UIApplication (Rising)

+ (UIViewController *)topViewController {
    UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self topViewControllerWithBase:rootVC];
}

+ (UIViewController *)topViewControllerWithBase:(UIViewController *)VC {
    if ([VC isKindOfClass:UINavigationController.class]) {
        return [self topViewControllerWithBase:((UINavigationController *)VC).visibleViewController];
    } else if ([VC isKindOfClass:UITabBarController.class]) {
        return [self topViewControllerWithBase:((UITabBarController *)VC).selectedViewController];
    }
    return VC;
}

@end
