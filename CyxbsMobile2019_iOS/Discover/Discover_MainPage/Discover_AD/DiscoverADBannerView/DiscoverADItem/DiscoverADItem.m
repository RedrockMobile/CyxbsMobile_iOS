//
//  DiscoverADItem.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADItem.h"

#pragma mark - DiscoverADItem ()

@interface DiscoverADItem ()

/// 显示图片
@property (nonatomic, strong) UIImageView *imgView;

@end

#pragma mark - DiscoverADItem

@implementation DiscoverADItem

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    [self addSubview:self.imgView];
}

#pragma mark - Lazy

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.SuperFrame];
        _imgView.image = [UIImage imageNamed:@"Discover_placeholder"];
        _imgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgView;
}

- (DiscoverADItem *)setImgURL:(NSString *)imgURL {
    [self.imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholder:[UIImage imageNamed:@"Discover_placeholder"]];
    return self;
}

#pragma mark - Method

- (DiscoverADItem *)withDefaultStyle {
    self.imgView.image = [UIImage imageNamed:@"Discover_placeholder"];
    return self;
}

@end
