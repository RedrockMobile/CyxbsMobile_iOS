//
//  StationGuideView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2022/5/13.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "StationGuideView.h"
#import "StationsCollectionViewCell.h"

@interface StationGuideView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) NSArray *stationArray;
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *busimgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *runtimeLabel;
@property (nonatomic, strong) UIButton *sendtypeBtn;
@property (nonatomic, strong) UIButton *runtypeBtn;
@property (nonatomic, copy) NSArray <NSString *> *defaultImgAry;

@end

@implementation StationGuideView

- (instancetype)initWithFrame:(CGRect)frame AndStationsData:(StationData *)data{
    self = [super initWithFrame: frame];
    if (self) {
        self.stationArray = data.stations;
        [self addSubview:self.busimgView];
        _busimgView.image = [UIImage imageNamed:self.defaultImgAry[data.line_id]];
        [self addSubview:self.titleLabel];
        _titleLabel.text = data.line_name;
        [self addSubview:self.runtimeLabel];
        _runtimeLabel.text = data.run_time;
        [self addSubview:self.runtypeBtn];
        [_runtypeBtn setTitle:data.run_type forState:UIControlStateNormal];
        [self addSubview:self.sendtypeBtn];
        [_sendtypeBtn setTitle:data.send_type forState:UIControlStateNormal];
        [self addSubview: self.collectionView];
        _collectionView.dataSource = self;
    }
    return self;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _stationArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StationsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.frontImageView.image = [UIImage imageNamed:@"originstation"];
        cell.frontImageView.frame = CGRectMake(16, 0, 24, 24);
        cell.backImageView.image = [UIImage imageNamed:@"busline"];
        cell.backImageView.frame = CGRectMake(27, 8, 19, 6);
    }else if (indexPath.row == _stationArray.count - 1) {
        cell.frontImageView.frame = CGRectMake(16, 0, 24, 24);
        cell.frontImageView.image = [UIImage imageNamed:@"terminalstation"];
        cell.backImageView.image = [UIImage imageNamed:@"busline"];
        cell.backImageView.frame = CGRectMake(0, 8, 25, 6);
    }else{
        cell.backImageView.frame = CGRectMake(0, 8, 46, 6);
        cell.backImageView.image = [UIImage imageNamed:@"busline.arrow"];
    }
    cell.stationLabel.text = _stationArray[indexPath.row][@"name"];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize  = CGSizeMake(46, 163);
         // 横向滚动
         layout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
         // cell间的间距
         layout.minimumLineSpacing  = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, 163) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1]];
        [_collectionView registerClass: [StationsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    }
    return _collectionView;
}
- (UIImageView *)busimgView {
    if (!_busimgView) {
        _busimgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 24, 36, 36)];
    }
    return _busimgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 27, 200, 31)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 22];
    }
    return _titleLabel;
}
- (UILabel *)runtimeLabel {
    if (!_runtimeLabel) {
        _runtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 160, 17)];
        _runtimeLabel.right = self.right - 16;
        _runtimeLabel.font = [UIFont fontWithName:PingFangSCLight size: 12];
        _runtimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _runtimeLabel;
}
- (UIButton *)sendtypeBtn {
    if (!_sendtypeBtn) {
        _sendtypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 62, 17)];
        _sendtypeBtn.titleLabel.font = [UIFont fontWithName:PingFangSCLight size: 11];
        [_sendtypeBtn setTitleColor: [UIColor colorNamed:@"7_191_225_1"] forState:UIControlStateNormal];
        _sendtypeBtn.backgroundColor = [UIColor colorNamed:@"7_191_225_0.09"];
        _sendtypeBtn.right = _runtypeBtn.left - 8;
        _sendtypeBtn.top = _runtimeLabel.bottom + 8;
        _sendtypeBtn.layer.cornerRadius = _sendtypeBtn.height / 2;
        _sendtypeBtn.userInteractionEnabled = NO;
    }
    return _sendtypeBtn;
}
- (UIButton *)runtypeBtn {
    if (!_runtypeBtn) {
        _runtypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 19)];
        _runtypeBtn.titleLabel.font = [UIFont fontWithName:PingFangSCLight size: 11];
        _runtypeBtn.right = self.right - 16;
        _runtypeBtn.top = _runtimeLabel.bottom + 8;
        _runtypeBtn.layer.cornerRadius = _runtypeBtn.height / 2;
        _runtypeBtn.userInteractionEnabled = NO;
        [_runtypeBtn setTitleColor:[UIColor colorNamed:@"255_69_185_1"] forState:UIControlStateNormal];
        _runtypeBtn.backgroundColor = [UIColor colorNamed:@"255_69_185_0.08"];
    }
    return _runtypeBtn;
}

- (NSArray<NSString *> *)defaultImgAry {
    if (_defaultImgAry == nil) {
        _defaultImgAry = @[
            @"PinkBus",
            @"OrangeBus",
            @"BlueBus",
            @"GreenBus",
            @"Compass"
        ];
    }
    return _defaultImgAry;
}
@end
