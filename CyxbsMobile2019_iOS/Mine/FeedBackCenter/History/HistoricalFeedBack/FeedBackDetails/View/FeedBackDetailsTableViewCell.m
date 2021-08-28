//
//  FeedBackDetailsTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsTableViewCell.h"

@interface FeedBackDetailsTableViewCell ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

/// 背景蒙版
@property (nonatomic, strong) UIView * maskView;

@end

@implementation FeedBackDetailsTableViewCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.maskView];
    [self.maskView addSubview:self.titleLabel];
    [self.maskView addSubview:self.subtitleLabel];
    [self.maskView addSubview:self.separateLine];
    [self.maskView addSubview:self.picturesCollectionView];
    [self.maskView addSubview:self.typeButton];
    // config self
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    // timelabel
    CGRect f6 = bounds;
    f6.size = [self.timeLabel sizeThatFits:CGSizeZero];
    f6.origin = CGPointMake((bounds.size.width - f6.size.width) / 2, 12);
    self.timeLabel.frame = f6;
    
    bounds.size.width -= 16 * 2;
    // titleLabel
    CGRect f1 = bounds;
    f1.origin = CGPointMake(18, 18);
    f1.size = [self.titleLabel sizeThatFits:CGSizeMake(bounds.size.width - 18 * 2, 0)];
    self.titleLabel.frame = f1;

    // separateLine
    CGRect f2 = bounds;
    f2.origin = CGPointMake(16, CGRectGetMaxY(f1) + 10);
    f2.size = CGSizeMake(bounds.size.width - 16 * 2, 1);
    self.separateLine.frame = f2;

    //subtitleLabel
    CGRect f3 = bounds;
    f3.origin = CGPointMake(f1.origin.x, CGRectGetMaxY(f2) + 10);
    f3.size = [self.subtitleLabel sizeThatFits:CGSizeMake(bounds.size.width - f3.origin.x * 2, 0)];
    self.subtitleLabel.frame = f3;

    // picturesCollectionView
    CGRect f4 = bounds;
    f4.origin = CGPointMake(f3.origin.x, CGRectGetMaxY(f3) + 10);
    CGFloat spaceWidth = 7.f;
    self.flowLayout.minimumLineSpacing = spaceWidth;
    self.flowLayout.minimumInteritemSpacing = spaceWidth;
    CGFloat cellWidth = self.cellModel.imgCount == 0 ? 0 : (bounds.size.width - f4.origin.x * 2 - spaceWidth * 2) / 3;
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    CGFloat collectionWidth = cellWidth * self.cellModel.imgCount + spaceWidth * (self.cellModel.imgCount - 1);;
    f4.size = CGSizeMake(collectionWidth, cellWidth);
    self.picturesCollectionView.frame = f4;
    
    // typeLabel
    CGRect f5 = bounds;
    f5.origin = CGPointMake(f4.origin.x, CGRectGetMaxY(f4) + 10);
    CGSize typeButtonSize = [self.typeButton sizeThatFits:CGSizeZero];
    typeButtonSize.width += 12 * 2;
    f5.size = typeButtonSize;
    self.typeButton.frame = f5;
    self.typeButton.layer.cornerRadius = typeButtonSize.height / 2;
    
    // maskeView
    CGRect flast = bounds;
    flast.origin = CGPointMake(16, CGRectGetMaxY(f6) + 12);
    flast.size = CGSizeMake(bounds.size.width, CGRectGetMaxY(self.typeButton.frame) + 18);
    self.maskView.frame = flast;
}

#pragma mark - setter

- (void)setCellModel:(FeedBackDetailsModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.subtitleLabel.text = cellModel.contentText;
    [self.typeButton setTitle:[@"#" stringByAppendingString:cellModel.type] forState:UIControlStateNormal];
    self.timeLabel.text = getTimeFromTimestampWithDateFormat(cellModel.date, @"YYYY/MM/dd HH:mm");
    
    [self layoutSubviews];
    [self.picturesCollectionView reloadData];
}

#pragma mark - private

- (CGFloat)height {
    return CGRectGetMaxY(self.maskView.frame) + 8;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        _titleLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _subtitleLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _subtitleLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        _subtitleLabel.numberOfLines = 0;
    }
    return _subtitleLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _separateLine.backgroundColor = [UIColor colorNamed:@"189_204_229_1&248_249_252_1"];
    }
    return _separateLine;
}

- (UICollectionView *)picturesCollectionView {
    if (_picturesCollectionView == nil) {
        _picturesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _picturesCollectionView.delegate = self;
        _picturesCollectionView.dataSource = self;
        _picturesCollectionView.scrollEnabled = NO;
        _picturesCollectionView.backgroundColor = [UIColor clearColor];
        [_picturesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _picturesCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UIButton *)typeButton {
    if (_typeButton == nil) {
        _typeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _typeButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:11];
        [_typeButton setTitleColor:[UIColor colorNamed:@"122_153_204_1&black_1"] forState:UIControlStateNormal];
        _typeButton.backgroundColor = [UIColor colorNamed:@"232_240_252_1&90_90_90_1"];
        _typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _typeButton;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorNamed:@"white_1&45_45_45_1"];
        _maskView.layer.cornerRadius = 8;
    }
    return _maskView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _timeLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellModel.imgCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.layer.cornerRadius = 4;
    return cell;
}

@end