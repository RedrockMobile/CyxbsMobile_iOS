//
//  FeedBackReplyTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackReplyTableViewCell.h"

@interface FeedBackReplyTableViewCell ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

/// 背景蒙版
@property (nonatomic, strong) UIView * maskView;

@end

@implementation FeedBackReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    [self.maskView addSubview:self.picturesCollectionView];
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
    
    // picturesCollectionView
    CGRect f2 = bounds;
    f2.origin = CGPointMake(f1.origin.x, CGRectGetMaxY(f1) + 10);
    CGFloat spaceWidth = 7.f;
    self.flowLayout.minimumLineSpacing = spaceWidth;
    self.flowLayout.minimumInteritemSpacing = spaceWidth;
    CGFloat cellWidth = self.cellModel.imgCount == 0 ? 0 : (bounds.size.width - f2.origin.x * 2 - spaceWidth * 2) / 3;
    CGFloat collectionWidth = cellWidth * self.cellModel.imgCount + spaceWidth * (self.cellModel.imgCount - 1);
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    f2.size = CGSizeMake(collectionWidth, cellWidth);
    self.picturesCollectionView.frame = f2;
    
    // maskeView
    CGRect flast = bounds;
    flast.origin = CGPointMake(16, CGRectGetMaxY(f6) + 12);
    flast.size = CGSizeMake(bounds.size.width, CGRectGetMaxY(self.picturesCollectionView.frame) + 18);
    self.maskView.frame = flast;
}

- (CGFloat)height {
    return CGRectGetMaxY(self.maskView.frame) + 8;
}

#pragma mark - setter

- (void)setCellModel:(FeedBackReplyModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = [@"回复:" stringByAppendingString:cellModel.contentText];
    self.timeLabel.text = [self getTimeFromTimestamp:cellModel.date];
    
    [self layoutSubviews];
    [self.picturesCollectionView reloadData];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _titleLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
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

#pragma mark - private

/// 将时间戳转化为字符串 @"YYYY/MM/dd HH:mm"
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

@end
