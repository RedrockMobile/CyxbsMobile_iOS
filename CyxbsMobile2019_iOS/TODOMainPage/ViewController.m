//
//  ViewController.m
//  ZY
//
//  Created by 欧阳紫浩 on 2021/8/17.
//

#import "ViewController.h"
#import "TODOMainViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jump:(id)sender {
    
    TODOMainViewController *tvc = [[TODOMainViewController alloc]init];
    
    [self.navigationController pushViewController:tvc animated:YES];
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
