//
//  IntegralStoreContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreContentView.h"
#import "WaterFallLayout.h"

@interface IntegralStoreContentView ()

@property (nonatomic, weak) UILabel *storeTitlelabel;
@property (nonatomic, weak) UIButton *myGoodsButton;
@property (nonatomic, weak) UIImageView *scoreImageView;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UIView *dragHintView;

@end

@implementation IntegralStoreContentView

#pragma mark - 子控件
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *storeView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            storeView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_StoreViewColor"];
        } else {
            storeView.backgroundColor = [UIColor whiteColor];
        }
        storeView.layer.cornerRadius = 16;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithGesture:)];
        [storeView addGestureRecognizer:panGesture];
        [self addSubview:storeView];
        self.storeView = storeView;
        
        UILabel *storeTitlelabel = [[UILabel alloc] init];
        storeTitlelabel.text = @"积分商城";
        storeTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        if (@available(iOS 11.0, *)) {
            storeTitlelabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            storeTitlelabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        }
        [self.storeView addSubview:storeTitlelabel];
        self.storeTitlelabel = storeTitlelabel;
        
        UIButton *myGoodsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [myGoodsButton setTitle:@"我的商品" forState:UIControlStateNormal];
        myGoodsButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [myGoodsButton setTitleColor:[UIColor colorWithRed:255/255.0 green:161/255.0 blue:146/255.0 alpha:1] forState:UIControlStateNormal];
        myGoodsButton.backgroundColor = [UIColor colorWithRed:248/255.0 green:226/255.0 blue:223/255.0 alpha:1];
        [myGoodsButton addTarget:self action:@selector(myGoodsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.storeView addSubview:myGoodsButton];
        self.myGoodsButton = myGoodsButton;
        
        UIImageView *scoreImageView = [[UIImageView alloc] init];
        scoreImageView.image = [UIImage imageNamed:@"积分"];
        [self.storeView addSubview:scoreImageView];
        self.scoreImageView = scoreImageView;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.text = [NSString stringWithFormat:@"%@", [UserItemTool defaultItem].integral];
        scoreLabel.font = [UIFont systemFontOfSize:18];
        if (@available(iOS 11.0, *)) {
            scoreLabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            scoreLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        }        [self.storeView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        
        // 提醒用户该view可拖拽
        UIView *dragHintView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            dragHintView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_DragHintViewColor"];
        } else {
            dragHintView.backgroundColor = [UIColor colorWithRed:226/255.0 green:237/255.0 blue:251/255.0 alpha:1.0];
        }        [self.storeView addSubview:dragHintView];
        self.dragHintView = dragHintView;
        
        WaterFallLayout *layout = [[WaterFallLayout alloc] init];
        UICollectionView *storeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 73, MAIN_SCREEN_W, MAIN_SCREEN_H - 73 - 30) collectionViewLayout:layout];
        if (IS_IPHONEX) {
            storeView.frame = CGRectMake(0, 88, MAIN_SCREEN_W, MAIN_SCREEN_H - 88 - 50);
        }
        if (@available(iOS 11.0, *)) {
            storeCollectionView.backgroundColor = [UIColor colorNamed:@"Mine_Store_BackgroundColor"];
        } else {
            storeCollectionView.backgroundColor = [UIColor whiteColor];
        }
        self.storeCollectionView = storeCollectionView;
        [self addSubview:storeCollectionView];
    }
    return self;
}


#pragma mark - 约束
- (void)layoutSubviews {
    if (IS_IPHONEX) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview).offset(50);
            make.leading.bottom.trailing.equalTo(self.superview);
        }];
    } else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview).offset(30);
            make.leading.bottom.trailing.equalTo(self.superview);
        }];
    }
    
    if (IS_IPHONEX) {
        [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(104));
        }];
    } else {
        [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(89));
        }];
    }
    
    [self.dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.storeView);
        make.top.equalTo(self.storeView).offset(9);
        make.height.equalTo(@6);
        make.width.equalTo(@30);
    }];
    self.dragHintView.layer.cornerRadius = 3;
    
    [self.storeTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeView).offset(22);
        make.leading.equalTo(self.storeView).offset(13);
    }];
    
    [self.myGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.leading.equalTo(self.storeTitlelabel.mas_trailing).offset(16);
        make.height.equalTo(@26);
        make.width.equalTo(@75);
    }];
    self.myGoodsButton.layer.cornerRadius = 13;
    
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.storeView).offset(-16);
    }];
    
    [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.scoreLabel.mas_leading).offset(-9);
        make.height.width.equalTo(@21);
    }];
}

- (void)dismissWithGesture:(UIPanGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(dismissWithGesture:)]) {
        [self.delegate dismissWithGesture:sender];
    }
}


#pragma mark - 按钮
- (void)myGoodsButtonTouched {
    if ([self.delegate respondsToSelector:@selector(myGoodsButtonTouched)]) {
        [self.delegate myGoodsButtonTouched];
    }
}

@end
