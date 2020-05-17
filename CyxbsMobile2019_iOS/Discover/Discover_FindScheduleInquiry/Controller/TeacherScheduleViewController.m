//
//  TeacherScheduleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TeacherScheduleViewController.h"
#define BACKGROUNDCOLOR  [UIColor colorNamed:@"Color#F8F9FC&#000101" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface TeacherScheduleViewController ()

@end

@implementation TeacherScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = BACKGROUNDCOLOR;
    } else {
        // Fallback on earlier versions
    }
    // Do any additional setup after loading the view.
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
