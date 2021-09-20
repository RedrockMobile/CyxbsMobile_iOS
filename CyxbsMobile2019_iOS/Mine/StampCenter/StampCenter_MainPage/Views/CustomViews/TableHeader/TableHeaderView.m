//
//  TableHeaderView.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/11.
//

#import "TableHeaderView.h"
#import "PrefixHeader.pch"
#import "TaskData.h"

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
            }
                } error:^{
                    NSLog(@"出错了");
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
        detailLabel.text = @"每日签到 +10";
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}


- (void)checkIn{
        HttpClient *client = [HttpClient defaultClient];
        [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
        [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *target = @"今日打卡";
            NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:data name:@"title"];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"成功了");
                self.button.backgroundColor = [UIColor colorNamed:@"gotoBtnHaveDoneBG"];
                [self.button setTitleColor:[UIColor colorNamed:@"gotoBtnTitleHaveDoneBG"] forState:UIControlStateNormal];
                self.button.enabled = NO;
                [self.button setTitle:@"已签到" forState:UIControlStateNormal];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"失败了");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkerror" object:nil];
            }];
    
//    [client requestWithJson:CHECKINAPI method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSLog(@"%@",responseObject);
//        NSLog(@"成功了");
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"出错了");
//        }];
}
@end
