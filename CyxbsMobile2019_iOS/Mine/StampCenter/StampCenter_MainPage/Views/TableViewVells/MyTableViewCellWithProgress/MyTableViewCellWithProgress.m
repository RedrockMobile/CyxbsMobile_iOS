//
//  MyTableViewCellWithProgress.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import "MyTableViewCellWithProgress.h"

@implementation MyTableViewCellWithProgress

- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor colorNamed:@"table"];
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.gotoButton];
        [self.contentView addSubview:self.progressBar];
        [self.contentView addSubview:self.progressBarHaveDone];
        [self.contentView addSubview:self.progressNumberLabel];
    }
    return self;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 8, 200, 22)];
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        mainLabel.textColor = [UIColor colorNamed:@"#15315B"];
        mainLabel.text = @"逛逛邮问";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 30,200, 20)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        detailLabel.text = @"浏览5条动态 +15";
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (GotoButton *)gotoButton{
    if (!_gotoButton) {
        GotoButton *gotobutton = [[GotoButton alloc]initWithFrame:CGRectMake(0.781*SCREEN_WIDTH, 30, 66, 28) AndTitle:@"去完成"];
        _gotoButton = gotobutton;
    }
    return _gotoButton;
}

- (UIView *)progressBar{
    if (!_progressBar) {
        UIView *progressBar = [[UIView alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 59, 150, 8)];
        progressBar.backgroundColor = [UIColor colorNamed:@"#E5E5E5"];
        progressBar.layer.cornerRadius = 4;
        _progressBar = progressBar;
    }
    return _progressBar;
}

- (UIView *)progressBarHaveDone{
    if (!_progressBarHaveDone) {
        UIView *progressBarHaveDone = [[UIView alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 59, 0, 8)];
        progressBarHaveDone.backgroundColor = [UIColor colorNamed:@"#7D8AFF"];
        progressBarHaveDone.layer.cornerRadius = 4;
        _progressBarHaveDone = progressBarHaveDone;
    }
    return _progressBarHaveDone;
}

- (UILabel *)progressNumberLabel{
    if (!_progressNumberLabel) {
        UILabel *progressNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.5*SCREEN_WIDTH, 55.5, 40, 17)];
        progressNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        progressNumberLabel.textColor = [UIColor colorNamed:@"#7D8AFF"];
        progressNumberLabel.text = @"1/5";
        _progressNumberLabel = progressNumberLabel;
    }
    return _progressNumberLabel;
}

- (void)setData:(TaskData *)data{
    self.mainLabel.text = data.title;
    self.detailLabel.text = data.Description;
    float f = (float)data.current_progress/(float)data.max_progress;//必须强转float，不然全都是0
    self.progressBarHaveDone.size = CGSizeMake(f*150, 8);
    self.progressNumberLabel.text = [NSString stringWithFormat:@"%d/%d",data.current_progress,data.max_progress];
    self.gotoButton.target = data.title;
    if (data.current_progress == data.max_progress) {
        self.gotoButton.backgroundColor = [UIColor colorNamed:@"gotoBtnHaveDoneBG"];
        [self.gotoButton setTitleColor:[UIColor colorNamed:@"gotoBtnTitleHaveDoneBG"] forState:UIControlStateNormal];
        self.gotoButton.enabled = NO;
        [self.gotoButton setTitle:@"已完成" forState:UIControlStateNormal];
    }
    [self.gotoButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
}

//做任务
- (void)test:(GotoButton *)sender{
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *target = sender.target;
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:data name:@"title"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"成功了");
          [TaskData TaskDataWithSuccess:^(NSArray * _Nonnull array) {
              TaskData *data = array[self.row];
              [self setData:data];
            } error:^{
                
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败了");
        }];
}
@end
