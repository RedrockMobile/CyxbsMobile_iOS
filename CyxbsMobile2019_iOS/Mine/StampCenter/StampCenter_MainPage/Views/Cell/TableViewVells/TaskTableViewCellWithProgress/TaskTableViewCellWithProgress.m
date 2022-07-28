//
//  TaskTableViewCellWithProgress.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import "TaskTableViewCellWithProgress.h"

@implementation TaskTableViewCellWithProgress

- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
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
        mainLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
        mainLabel.text = @"逛逛邮问";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 30,200, 20)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.4] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];;
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
        progressBar.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E5E5E5" alpha:1] darkColor:[UIColor colorWithHexString:@"#E5E5E5" alpha:0.2]];
        progressBar.layer.cornerRadius = 4;
        _progressBar = progressBar;
    }
    return _progressBar;
}

- (UIView *)progressBarHaveDone{
    if (!_progressBarHaveDone) {
        UIView *progressBarHaveDone = [[UIView alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 59, 0, 8)];
        progressBarHaveDone.backgroundColor = [UIColor colorWithHexString:@"#7D8AFF"];
        progressBarHaveDone.layer.cornerRadius = 4;
        _progressBarHaveDone = progressBarHaveDone;
    }
    return _progressBarHaveDone;
}

- (UILabel *)progressNumberLabel{
    if (!_progressNumberLabel) {
        UILabel *progressNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.5*SCREEN_WIDTH, 55.5, 40, 17)];
        progressNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        progressNumberLabel.textColor = [UIColor colorWithHexString:@"#7D8AFF"];
        progressNumberLabel.text = @"1/5";
        _progressNumberLabel = progressNumberLabel;
    }
    return _progressNumberLabel;
}

- (void)setData:(StampTaskData *)data{
    self.mainLabel.text = data.title;
    self.detailLabel.text =[ NSString stringWithFormat:@"%@ +%d",data.Description,data.gain_stamp];
    float f = (float)data.current_progress/(float)data.max_progress;//必须强转float，不然全都是0
    self.progressBarHaveDone.size = CGSizeMake(f*150, 8);
    self.progressNumberLabel.text = [NSString stringWithFormat:@"%d/%d",data.current_progress,data.max_progress];
    self.gotoButton.target = data.title;
    if (data.current_progress == data.max_progress) {
        self.gotoButton.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#C1C1C1" alpha:1] darkColor:[UIColor colorWithHexString:@"#474747" alpha:1]];
        [self.gotoButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000101" alpha:1]] forState:UIControlStateNormal];
        self.gotoButton.enabled = NO;
        [self.gotoButton setTitle:@"已完成" forState:UIControlStateNormal];
    }
    [self.gotoButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
}

//做任务
- (void)test:(GotoButton *)sender{
    if ([sender.target isEqualToString:@"斐然成章"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToReleaseDynamic" object:nil];
    }else if ([sender.target isEqualToString:@"绑定志愿者账号"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToZhiyuan" object:nil];
    }else if ([sender.target isEqualToString:@"完善个人信息"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToProfile" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToNewQA" object:nil];
    }
}
@end
