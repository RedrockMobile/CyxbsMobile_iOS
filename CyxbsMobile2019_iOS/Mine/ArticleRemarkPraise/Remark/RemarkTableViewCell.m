//
//  RemarkTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemarkTableViewCell.h"

@interface RemarkTableViewCell()

/// 自己的评论/动态的内容label
@property(nonatomic,strong)UILabel * contentLabel;
/// 别人对自己的评论内容label
@property(nonatomic,strong)UILabel * remarkLabel;

@property(nonatomic,strong)UIButton *praiseBtn;

@property(nonatomic,strong)UIButton *remarkBtn;
@end

@implementation RemarkTableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addContentLabel];
        [self addRemarkLabel];
        [self addRemarkBtn];
        [self addPraiseBtn];
    }
    return self;
}
- (void)addContentLabel {
    UILabel *label = [[UILabel alloc] init];
    self.contentLabel = label;
    [self.contentView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:15];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.188*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.1987*MAIN_SCREEN_W);
    }];
}

- (void)addRemarkLabel {
    UILabel *label = [[UILabel alloc] init];
    self.remarkLabel = label;
    [self.contentView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"85_108_139&131_131_132"];
    } else {
        label.textColor = [UIColor colorWithRed:85/255.0 green:108/255.0 blue:139/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:15];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.204*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.2627*MAIN_SCREEN_W);
    }];
}
- (void)addPraiseBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.praiseBtn = btn;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.36*SCREEN_WIDTH);
        make.bottom.equalTo(self.contentView).offset(-0.072*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05426*SCREEN_WIDTH);
        make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
    }];
    
    self.praiseBtn.selected = NO;
    
    //41/51
    [btn setBackgroundImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addRemarkBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.remarkBtn = btn;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.188*SCREEN_WIDTH);
        make.bottom.equalTo(self.contentView).offset(-0.072*SCREEN_WIDTH);
        make.width.mas_equalTo(0.05426*SCREEN_WIDTH);
        make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
    }];
    

    [btn setBackgroundImage:[UIImage imageNamed:@"answerIcon"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)praiseBtnClicked {
    if (self.praiseBtn.selected) {
        self.praiseBtn.selected = NO;
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"未点赞"] forState:UIControlStateNormal];
        [self.praiseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.05426*SCREEN_WIDTH);
        }];
    }else {
        self.praiseBtn.selected = YES;
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [self.praiseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0675*SCREEN_WIDTH);
        }];
    }
}

- (void)remarkBtnClicked {
    
}

- (void)setModel:(RemarkParseModel *)model {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.publish_time.doubleValue];
    if ([date isToday]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld %ld:%ld",components.year,components.month,components.day,components.hash,components.minute];
    }else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld",components.year,components.month,components.day];
    }
    
    if (model.nick_name==nil||[model.nick_name isEqualToString:@""]) {
        self.nickNameLabel.text = @"匿名用户";
    }else {
        self.nickNameLabel.text = model.nick_name;
    }
    
    if (model.from_nickname==nil||[model.from_nickname isEqualToString:@""]) {
        self.interactionInfoLabel.text = @"评论了你的评论";
    }else {
        self.interactionInfoLabel.text = @"评论了你的动态";
    }
    
    if (![model.avatar isEqual:@""]&&model.avatar!=nil) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    }
    
    self.remarkLabel.text = model.content;
    self.contentLabel.text = model.from;
    
}

@end
