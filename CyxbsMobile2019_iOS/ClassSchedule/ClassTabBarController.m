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
}



@end
