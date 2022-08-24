//
//  ScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleController.h"

#import "ScheduleInteractorRequest.h"

@interface ScheduleController ()

@end

@implementation ScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScheduleModel *m = [[ScheduleModel alloc] init];
    
    ScheduleInteractorRequest *request = [ScheduleInteractorRequest requestBindingModel:m];
    [request
     request:@{
        student : @[@"2021215154"]
    }
     success:^{
        
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
