//
//  MGDImageCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/2/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDImageCollectionViewCell.h"

@implementation MGDImageCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 7.5;
        
        _countLabel = [self ImageCountLabel];
        [self.contentView addSubview:_countLabel];
        _countLabel.hidden = YES;
        
    }
    return self;
}

- (UILabel *)ImageCountLabel {
    UILabel *imageCountLabel = [[UILabel alloc] init];
    imageCountLabel.backgroundColor = [UIColor blackColor];
    imageCountLabel.alpha = 0.4;
    imageCountLabel.layer.cornerRadius = 7.5;
    imageCountLabel.textAlignment = NSTextAlignmentCenter;
    imageCountLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    imageCountLabel.font = [UIFont fontWithName:@"Arial" size: 30];
    imageCountLabel.layer.masksToBounds = YES;
    return imageCountLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.frame;
    _countLabel.frame = _imageView.frame;
}

@end
