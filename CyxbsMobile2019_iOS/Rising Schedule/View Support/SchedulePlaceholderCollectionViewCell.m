//
//  SchedulePlaceholderCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/3/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "SchedulePlaceholderCollectionViewCell.h"

NSString *SchedulePlaceholderCollectionViewCellReuseIdentifier = @"SchedulePlaceholderCollectionViewCell";

#pragma mark - SchedulePlaceholderCollectionViewCell ()

@interface SchedulePlaceholderCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SchedulePlaceholderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.imgView.width = layoutAttributes.size.width - 40;
    self.imgView.height = self.imgView.width * 0.65;
    self.imgView.center = CGPointMake(layoutAttributes.size.width / 2, layoutAttributes.size.height / 2);
}

#pragma mark - Lazy

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = UIColor.clearColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.image = [UIImage imageNamed:@"empty.schedule.empty"];
    }
    return _imgView;
}

#pragma mark - caculate

- (void)setIsError404:(BOOL)isError404 {
    _isError404 = isError404;
    if (isError404) {
        self.imgView.image = [UIImage imageNamed:@"empty.404"];
    } else {
        self.imgView.image = [UIImage imageNamed:@"empty.schedule.empty"];
    }
}

@end
