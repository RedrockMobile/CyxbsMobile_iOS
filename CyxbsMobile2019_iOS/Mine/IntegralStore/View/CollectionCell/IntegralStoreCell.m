//
//  IntegralStoreCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreCell.h"
#import "IntegralStoreDataItem.h"

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
        make.bottom.equalTo(self).offset(-37);
    }];
}

@end
