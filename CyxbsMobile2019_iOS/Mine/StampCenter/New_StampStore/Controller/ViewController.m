//
//  ViewController.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/4.
//

#import "ViewController.h"

#import "StampCenterVC.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
   
}
- (IBAction)jumptomain:(id)sender {
    StampCenterVC *svc = [[StampCenterVC alloc]init];
    
    [self.navigationController pushViewController:svc animated:YES];
}


@end
