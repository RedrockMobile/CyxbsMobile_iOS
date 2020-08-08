//
//  CQUPTMapViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapViewController.h"
#import "CQUPTMapContentView.h"

@interface CQUPTMapViewController ()

@property (nonatomic, weak) CQUPTMapContentView *contentView;

@end

@implementation CQUPTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CQUPTMapContentView *contentView = [[CQUPTMapContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

@end
