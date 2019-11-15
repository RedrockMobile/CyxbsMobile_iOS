//
//  LQQFinderToolViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "LQQFinderToolViewController.h"
#import "FinderToolViewItem.h"
@interface LQQFinderToolViewController ()

@end

@implementation LQQFinderToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];

    FinderToolViewItem *testFinderView = [[FinderToolViewItem alloc]initWithIconView:@"教室查询" Title:@"教室查询" Detail:@"帮助同学们更快的查找到课表"];
    testFinderView.frame = CGRectMake(0, 0, 200, 300);
    [self.view addSubview:testFinderView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
