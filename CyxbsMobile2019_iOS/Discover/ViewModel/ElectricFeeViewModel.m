//
//  ElectricFeeViewModel.m
//  MoblieCQUPT_iOS
//
//  Created by 千千 on 2019/10/28.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "ElectricFeeViewModel.h"
#import "LQQGlanceView.h"
@interface ElectricFeeViewModel()
@property ElectricFeeModel *model;
@property LQQGlanceView *bindView;

@end
@implementation ElectricFeeViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        ElectricFeeModel *model = [[ElectricFeeModel alloc]init];
        self.model = model;
        self.degree = @"50.2";
        self.money = @"12.42";
        self.time = @"1666年抄表";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"electricFeeDataSucceed" object:nil];
    }
    return self;
}
- (void) bindView: (LQQGlanceView*)view{
    self.bindView = view;
}
- (void) refreshData {
    self.bindView.electricFeeMoney.text = self.model.money;
    self.bindView.electricFeeDegree.text = self.model.degree;
    self.bindView.electricFeeTime.text = self.model.time;

}

@end
