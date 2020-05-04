//
//  MyGoodsTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/3.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsTableViewCell.h"


@interface MyGoodsTableViewCell ()

@property (nonatomic, weak) UIView *separatorLine;

@end


@implementation MyGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:photoImageView];
        self.photoImageView = photoImageView;
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            nameLabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            nameLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = nameLabel.textColor;
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.alpha = 0.6;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        
        UIImageView *integralImageView = [[UIImageView alloc] init];
        integralImageView.image = [UIImage imageNamed:@"积分"];
        [self.contentView addSubview:integralImageView];
        self.integralImageView = integralImageView;
        
        
        UILabel *integralLabel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            integralLabel.textColor = [UIColor colorNamed:@"Mine_Store_IntegralColor"];
        } else {
            integralLabel.textColor = [UIColor colorWithRed:58/255.0 green:52/255.0 blue:210/255.0 alpha:1];
        }
        integralLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        [self.contentView addSubview:integralLabel];
        self.integralLabel = integralLabel;
        
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = self.timeLabel.textColor;
        numLabel.font = self.timeLabel.font;
        numLabel.alpha = 0.6;
        [self.contentView addSubview:numLabel];
        self.numLabel = numLabel;
        
        
        UIView *separatorLine = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            separatorLine.backgroundColor = [UIColor colorNamed:@"Mine_EditInfo_SeparatorColor"];
        } else {
            separatorLine.backgroundColor = [UIColor colorWithRed:189/255.0 green:204/255.0 blue:229/255.0 alpha:1];
        }
        [self.contentView addSubview:separatorLine];
        self.separatorLine = separatorLine;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView).offset(12);
        make.height.width.equalTo(@88);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImageView);
        make.leading.equalTo(self.photoImageView.mas_trailing).offset(12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        make.leading.equalTo(self.nameLabel);
    }];
    
    [self.integralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.width.equalTo(@14);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.integralImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.integralImageView);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.integralImageView.mas_bottom).offset(10);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
}

@end
