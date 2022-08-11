//
//  SportAttendanceTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SportAttendanceTableViewCell.h"
#import "Masonry.h"

@implementation SportAttendanceTableViewCell

//重写cell的方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FBFCFF"] darkColor:[UIColor colorWithHexString:@"#1D1D1D"]];
        [self configUI];
        }
    return self;
}

- (void)configUI {
    //背景
    UIImageView *backGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sportcellbackground"]];
    backGround.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:backGround];
    [backGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(6);
        make.bottom.equalTo(self.contentView);
    }];
    
    //打卡日期
    [self.contentView addSubview:self.dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backGround).offset(12);
        make.left.equalTo(backGround).offset(28);
    }];
    
    //时间图标
    UIImageView *timeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"体育时间"]];
    [self.contentView addSubview:timeImgView];
    [timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.dateLab.mas_bottom).offset(12);
        make.left.equalTo(self.dateLab);
    }];
    
    //打卡时间
    [self.contentView addSubview:self.timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeImgView);
        make.left.equalTo(timeImgView.mas_right).offset(7);
    }];
    
    //地点图标
    UIImageView *spotImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"体育定位"]];
    [self.contentView addSubview:spotImgView];
    [spotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLab);
        make.centerX.equalTo(self.contentView).offset(-27);
    }];
    
    //打卡地点
    [self.contentView addSubview:self.spotLab];
    [_spotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLab);
        make.left.equalTo(spotImgView.mas_right).offset(7);
    }];
    
    //打卡类型
    [self.contentView addSubview:self.typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLab);
        make.right.equalTo(self.contentView).offset(-35);
    }];
    
    //打卡图标
    UIImageView *typeImgView = [[UIImageView alloc] init];
    if ([self.typeLab.text isEqualToString:@"跑步"]) {
        typeImgView.image = [UIImage imageNamed:@"体育跑步"];
    }else{
        typeImgView.image = [UIImage imageNamed:@"体育其他"];
    }
    [self.contentView addSubview:typeImgView];
    [typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLab);
        make.right.equalTo(self.typeLab.mas_left).offset(-7);
    }];
    
    //添加有效/无效
    if (_valid) {
        self.valiImgView.image = [UIImage imageNamed:@"体育有效"];
    }else{
        self.valiImgView.image = [UIImage imageNamed:@"体育无效"];
    }
    [self.contentView addSubview:self.valiImgView];
    [_valiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateLab);
        make.right.equalTo(self.contentView).offset(-36);
    }];

    //如果是奖励则添加奖励图标
    if (_is_award) {
        self.awardImgView.image = [UIImage imageNamed:@"体育奖励"];
        [self.contentView addSubview:self.awardImgView];
        [_awardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLab);
            make.left.equalTo(self.dateLab.mas_right).offset(7);
        }];
    }
}

#pragma mark - Setter

//重写setter方法
- (void)setSa:(SportAttendanceItem *)sa{
    if (_sa != sa) {
        _sa = sa;
        self.dateLab.text = sa.date;
        self.timeLab.text = sa.time;
        self.spotLab.text = sa.spot;
        self.typeLab.text = sa.type;
        self.dateLab.text = sa.date;
        self.timeLab.text = sa.time;
        self.spotLab.text = sa.spot;
        self.typeLab.text = sa.type;
        self.valid = sa.valid;
        self.is_award = sa.is_award;
        [self configUI];
    }
}

#pragma mark - Getter

- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLab.font = [UIFont fontWithName:PingFangSCBold size:16];
        _dateLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B"] darkColor:[UIColor colorWithHexString:@"#F0F0F2"]];
    }
    return _dateLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _timeLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.8] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    }
    return _timeLab;
}

- (UILabel *)spotLab{
    if (!_spotLab) {
        _spotLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _spotLab.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _spotLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.8] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    }
    return _spotLab;
}

- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _typeLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.8] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    }
    return _typeLab;
}


- (UIImageView *)valiImgView{
    if (!_valiImgView) {
        _valiImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _valiImgView;
}

- (UIImageView *)awardImgView{
    if (!_awardImgView) {
        _awardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _awardImgView;
}

@end
