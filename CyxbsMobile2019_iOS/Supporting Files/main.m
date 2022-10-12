//
//  main.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CyxbsApplication.h"

int main(int argc, char * argv[]) {
    NSString * principalClassName;
    NSString * appDelegateClassName;
    @autoreleasepool {
        principalClassName = NSStringFromClass([CyxbsApplication class]);
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, principalClassName, appDelegateClassName);
}
