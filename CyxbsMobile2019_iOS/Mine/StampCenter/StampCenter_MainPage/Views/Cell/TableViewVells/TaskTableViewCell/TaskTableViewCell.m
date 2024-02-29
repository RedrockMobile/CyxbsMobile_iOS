//
//  TaskTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2024/2/28.
//  Copyright © 2024 Redrock. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.gotoButton];
    }
    return self;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0427*SCREEN_WIDTH, 10, 200, 22)];
        mainLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
//        mainLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        mainLabel.text = @"逛逛邮问";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (GotoButton *)gotoButton{
    if (!_gotoButton) {
        GotoButton *gotobutton = [[GotoButton alloc]initWithFrame:CGRectMake(0.781*SCREEN_WIDTH, 9, 66, 28) AndTitle:@"去完成"];
        _gotoButton = gotobutton;
    }
    return _gotoButton;
}

- (void)setData:(StampTaskData *)data{
    NSString *addString = [NSString stringWithFormat:@"+%d", data.gain_stamp];;
    NSString *combinedString = [NSString stringWithFormat:@"%@ %@", data.title, addString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:combinedString];
    NSRange firstStringRange = NSMakeRange(0, data.title.length);
    NSRange secondStringRange = NSMakeRange(data.title.length + 1, addString.length);

    NSDictionary *firstStringAttributes = @{NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]]};
    NSDictionary *secondStringAttributes = @{NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#A1ADBD" alpha:1] darkColor:[UIColor colorWithHexString:@"#A1ADBD" alpha:1]]};

    [attributedText addAttributes:firstStringAttributes range:firstStringRange];
    [attributedText addAttributes:secondStringAttributes range:secondStringRange];
    self.mainLabel.attributedText = attributedText;
    
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
    }else if ([sender.target isEqualToString:@"发表一次动态"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToAttitude" object:nil];
    }else if ([sender.target isEqualToString:@"使用美食板块"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFood" object:nil];
    }else if ([sender.target isEqualToString:@"使用一次没课约"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToWeDate" object:nil];
    }else if ([sender.target isEqualToString:@"在表态广场完成一次表态"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToProfile" object:nil];
    }else if ([sender.target isEqualToString:@"今日打卡"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkInToday" object:nil];
    }else if ([sender.target isEqualToString:@"参加一次活动"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToActivity" object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToProfile" object:nil];
    }
}
@end
