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
        }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.dateLab];
    _dateLab.frame = CGRectMake(10, 10, 120, 20);
    
    [self.contentView addSubview:self.timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(20);
        make.right.equalTo(self.dateLab.mas_right).offset(20);
        make.left.equalTo(self.dateLab.mas_left);
        make.bottom.equalTo(self.timeLab.mas_top).offset(50);
    }];
    
    [self.contentView addSubview:self.spotLab];
    [_spotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(20);
        make.left.equalTo(self.timeLab.mas_right).offset(20);
        make.right.equalTo(self.spotLab.mas_right).offset(80);
//        make.bottom.equalTo(self.spotLab.mas_top).offset(50);
    }];
    
    [self.contentView addSubview:self.typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom).offset(20);
        make.left.equalTo(self.spotLab.mas_right).offset(20);
        make.right.equalTo(self.typeLab.mas_right).offset(80);
//        make.bottom.equalTo(self.contentView);
    }];
    
    if (_valid) {
        self.valiLab.text = @"有效";
    }else{
        self.valiLab.text = @"无效";
    }
    [self.contentView addSubview:self.valiLab];
    [_valiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab);
        make.left.equalTo(self.contentView).offset(200);
        make.right.equalTo(self.contentView).offset(10);
//        make.bottom.equalTo(self.contentView);
    }];

    //如果是奖励则添加奖励图标
    if (_is_award) {
        self.awardImgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.awardImgView];
        [_awardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_right).offset(-30);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
}

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

- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _dateLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _timeLab;
}

- (UILabel *)spotLab{
    if (!_spotLab) {
        _spotLab = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _spotLab;
}

- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _typeLab;
}

- (UILabel *)valiLab{
    if (!_valiLab) {
        _valiLab = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _valiLab;
}

- (UIImageView *)awardImgView{
    if (!_awardImgView) {
        _awardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _awardImgView;
}

@end
