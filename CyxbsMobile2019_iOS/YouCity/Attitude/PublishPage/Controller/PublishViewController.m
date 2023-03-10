//
//  PublishViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

// VC
#import "PublishViewController.h"
// View
#import "PublishTopView.h"

@interface PublishViewController ()
@property (nonatomic, strong) PublishTopView *topView;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
}

- (PublishTopView *)topView {
    if (!_topView) {
        CGFloat h = getStatusBarHeight_Double + 44;
        _topView = [[PublishTopView alloc] initWithTopView];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, h);
        [_topView.backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
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
