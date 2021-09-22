//
//  TableHeaderView.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/11.
//

#import "TableHeaderView.h"
#import "PrefixHeader.pch"
#import "TaskData.h"
#import "CheckInModel.h"

@implementation TableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self addSubview:self.button];
        [self addSubview:self.mainLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor colorNamed:@"table"];
    UIBezierPath  *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame =self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (GotoButton *)button{
    if (!_button) {
       GotoButton *button = [[GotoButton alloc]initWithFrame:CGRectMake(0.781*SCREEN_WIDTH, 32, 66, 28) AndTitle:@"去签到"];
        [TaskData TaskDataWithSuccess:^(NSArray * _Nonnull array) {
                    TaskData *data = array[0];
            if (data.current_progress == data.max_progress) {
                self.button.backgroundColor = [UIColor colorNamed:@"gotoBtnHaveDoneBG"];
                [self.button setTitleColor:[UIColor colorNamed:@"gotoBtnTitleHaveDoneBG"] forState:UIControlStateNormal];
                self.button.enabled = NO;
                [self.button setTitle:@"已签到" forState:UIControlStateNormal];
                self.detailLabel.text = [NSString stringWithFormat:@"明日签到 +%d",  ([[UserItemTool defaultItem].checkInDay intValue]+2)*5];
            }
                } error:^{
            
                }];
        [button addTarget:self action:@selector(checkIn) forControlEvents:UIControlEventTouchUpInside];
        _button = button;
    }
    return _button;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 24, 64, 22)];
        mainLabel.text = @"今日打卡";
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        mainLabel.textColor = [UIColor colorNamed:@"#15315B"];
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 50, 91, 20)];
        detailLabel.text = [NSString stringWithFormat:@"每日签到 +%d",  ([[UserItemTool defaultItem].checkInDay intValue]+2)*5];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}


- (void)checkIn{
    [CheckInModel CheckInSucceeded:^{
        self.button.backgroundColor = [UIColor colorNamed:@"gotoBtnHaveDoneBG"];
        [self.button setTitleColor:[UIColor colorNamed:@"gotoBtnTitleHaveDoneBG"] forState:UIControlStateNormal];
        self.button.enabled = NO;
        [self.button setTitle:@"已签到" forState:UIControlStateNormal];
        self.detailLabel.text = [NSString stringWithFormat:@"明日签到 +%d",  ([[UserItemTool defaultItem].checkInDay intValue]+2)*5];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
        } Failed:^(NSError * _Nonnull err) {
            NSLog(@"出错了");
        }];

}
@end
