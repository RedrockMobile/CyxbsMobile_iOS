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
    [self.contentView addSubview:self.maskView];
    [self.maskView addSubview:self.titleLabel];
    [self.maskView addSubview:self.subtitleLabel];
    [self.maskView addSubview:self.separateLine];
    [self.maskView addSubview:self.picturesCollectionView];
    [self.maskView addSubview:self.typeLabel];
    // config self
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
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

    // typeLabel
    CGRect f5 = bounds;
    f5.origin = CGPointMake(f4.origin.x, CGRectGetMaxY(f4) + 10);
    CGSize typeLabelSize = [self.typeLabel sizeThatFits:CGSizeZero];
    typeLabelSize.width += 12 * 2;
    typeLabelSize.height += 4 * 2;
    f5.size = typeLabelSize;
    self.typeLabel.frame = f5;
    self.typeLabel.layer.cornerRadius = 20;
    
    // maskeView
    CGRect flast = bounds;
    flast.origin = CGPointMake(16, 8);
    flast.size = CGSizeMake(bounds.size.width, CGRectGetMaxY(self.typeLabel.frame) + 18);
    self.maskView.frame = flast;
}

#pragma mark - setter

- (void)setCellModel:(FeedBackDetailsModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.subtitleLabel.text = cellModel.contentText;
    self.typeLabel.text = [@"#" stringByAppendingString:cellModel.type];
    
    [self layoutSubviews];
    [self.picturesCollectionView reloadData];
}

#pragma mark - private

- (NSString *)getTimeFromTimestamp:(long)time {
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    //将时间转换为字符串
    NSString * timeStr = [formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (CGFloat)height {
    return self.maskView.frame.size.height + 8 * 2;
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

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.font = [UIFont fontWithName:PingFangSCMedium size:11];
        _typeLabel.textColor = [UIColor colorNamed:@"122_153_204_1&black_1"];
        _typeLabel.backgroundColor = [UIColor colorNamed:@"232_240_252_1&90_90_90_1"];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 20;
    }
    return _typeLabel;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorNamed:@"white_1&45_45_45_1"];
        _maskView.layer.cornerRadius = 8;
    }
    return _maskView;
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
