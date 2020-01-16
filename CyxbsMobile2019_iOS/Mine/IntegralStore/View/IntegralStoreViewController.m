//
//  IntegralStoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreViewController.h"
#import "CheckInViewController.h"

@interface IntegralStoreViewController () <IntegralStoreContentViewDelegate>

@end

@implementation IntegralStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];

    IntegralStoreContentView *contentView = [[IntegralStoreContentView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)dismissWithGesture:(UIPanGestureRecognizer *)gesture {
    ((CheckInViewController *)self.transitioningDelegate).presentPanGesture = gesture;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
