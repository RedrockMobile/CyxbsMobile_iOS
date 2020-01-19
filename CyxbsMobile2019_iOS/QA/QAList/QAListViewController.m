//
//  QAListViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAListViewController.h"

@interface QAListViewController ()
@property(strong,nonatomic)UITableView *tableView;
@end

@implementation QAListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (instancetype)initViewStyle:(NSString *)style{
    self = [super init];
    self.title = style;
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
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
