//
//  CQUPTMapMoreImageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapMoreImageViewController.h"
#import "CQUPTMapImageLayout.h"
#import "CQUPTMapAllImageCollectionViewCell.h"
#import "CQUPTMapPlaceDetailItem.h"

@interface CQUPTMapMoreImageViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) CQUPTMapPlaceDetailItem *detailItem;

@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *shareImageView;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UICollectionView *imageCollectionView;
@property (nonatomic, weak) UILabel *noMoreImageLabel;

@end

@implementation CQUPTMapMoreImageViewController

- (instancetype)initWithPlaceDetailItem:(CQUPTMapPlaceDetailItem *)detailItem {
    if (self = [super init]) {
        self.detailItem = detailItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    self.backButton = backButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"所有图片";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:23];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = [UIColor colorNamed:@"Map_TextColor"];
    } else {
        titleLabel.textColor = [UIColor colorWithHexString:@"15305B"];
    }
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Map_Share_MoreImage"]];
    [self.view addSubview:shareImageView];
    self.shareImageView = shareImageView;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareButton.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
    [shareButton setTitle:@"与大家分享你拍摄的此地点" forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        [shareButton setTitleColor:[UIColor colorNamed:@"Map_ShareButtonColor_MoreImage"] forState:UIControlStateNormal];
    } else {
        [shareButton setTitleColor:[UIColor colorWithHexString:@"01CAF0"] forState:UIControlStateNormal];
    }
    [self.view addSubview:shareButton];
    self.shareButton = shareButton;
    
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[CQUPTMapImageLayout alloc] init]];
    [imageCollectionView registerClass:[CQUPTMapAllImageCollectionViewCell class] forCellWithReuseIdentifier:@"CQUPTMapAllImageCollectionViewCell"];
    imageCollectionView.backgroundColor = [UIColor clearColor];
    imageCollectionView.dataSource = self;
    [self.view addSubview:imageCollectionView];
    self.imageCollectionView = imageCollectionView;
}

- (void)viewDidLayoutSubviews {
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT + 15);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton);
        make.top.equalTo(self.backButton.mas_bottom).offset(34);
    }];
    
    [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.shareButton.mas_leading).offset(-5);
        make.width.height.equalTo(@16);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.view).offset(-15);
    }];
    
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(19.5);
        make.bottom.equalTo(self.view).offset(-45);
    }];
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.detailItem.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CQUPTMapAllImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CQUPTMapAllImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.detailItem.imagesArray[indexPath.item]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    
    return cell;
}

@end
