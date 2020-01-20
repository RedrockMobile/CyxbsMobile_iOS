//
//  IntegralStoreCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreCell.h"
#import "IntegralStoreDataItem.h"

@interface IntegralStoreCell ()

@property (nonatomic, weak) UIImageView *photoImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *numberLabel;
@property (nonatomic, weak) UIImageView *integralImageView;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UIButton *buyButton;

@end

@implementation IntegralStoreCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)setItem:(IntegralStoreDataItem *)item {
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:251/255.0 alpha:1.0];
    self.layer.cornerRadius = 8;
    
    UIImageView *photoImageView = [[UIImageView alloc] init];
    [self addSubview:photoImageView];
    photoImageView.layer.cornerRadius = 8;
    photoImageView.clipsToBounds = YES;
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView = photoImageView;
    
    NSURL *imageURL = [NSURL URLWithString:item.photo_src];
    [self.photoImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"签到背景"] options:SDWebImageRefreshCached];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = item.name;
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = [NSString stringWithFormat:@"仅剩%@件", item.num];
    numLabel.font = [UIFont systemFontOfSize:10];
    numLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0.58];
    [self addSubview:numLabel];
    self.numberLabel = numLabel;
    
    UIImageView *integralImageView = [[UIImageView alloc] init];
    integralImageView.image = [UIImage imageNamed:@"积分"];
    [self addSubview:integralImageView];
    self.integralImageView = integralImageView;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = item.value;
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    priceLabel.textColor = [UIColor colorWithRed:58/255.0 green:52/255.0 blue:210/255.0 alpha:1.0];
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    buyButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0];
    [buyButton setTitle:@"兑换" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:buyButton];
    self.buyButton = buyButton;
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-9);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(9);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.bottom.equalTo(self.integralImageView.mas_top).offset(-11);
    }];
    
    [self.integralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.height.width.equalTo(@14);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.integralImageView);
        make.leading.equalTo(self.integralImageView.mas_trailing).offset(3);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.integralImageView);
        make.trailing.equalTo(self).offset(-9);
        make.height.equalTo(@24);
        make.width.equalTo(@47);
    }];
    self.buyButton.layer.cornerRadius = 12;
}

@end
