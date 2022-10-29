//
//  PlaceholderCollectionReusableView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "PlaceholderCollectionReusableView.h"

#import "SameDrawUI.h"

NSString *PlaceholderCollectionReusableViewReuseIdentifier = @"PlaceholderCollectionReusableView";

#pragma mark - PlaceholderCollectionReusableView ()

@interface PlaceholderCollectionReusableView ()

/// img view
@property (nonatomic, strong) UIImageView *imgView;

/// content lab
@property (nonatomic, strong) UILabel *contentLab;

@end

#pragma mark - PlaceholderCollectionReusableView

@implementation PlaceholderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.contentLab];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGRect frame = layoutAttributes.frame;
    self.imgView.centerX = frame.size.width / 2;
    
}

#pragma mark - Setter

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CyxbsEmptyImageName.kebiao]];
    }
    return _imgView;
}

@end
