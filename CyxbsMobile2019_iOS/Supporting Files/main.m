//
//  main.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    StartTime = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSLog(@"App home path: %@", documentPath);
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
