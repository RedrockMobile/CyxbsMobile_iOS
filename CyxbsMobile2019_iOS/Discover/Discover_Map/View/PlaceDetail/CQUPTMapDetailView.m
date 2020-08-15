//
//  CQUPTDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapDetailView.h"
#import "CQUPTMapPlaceItem.h"
#import "CQUPTMapPlaceDetailItem.h"

@interface CQUPTMapDetailView ()

@property (nonatomic, weak) UIView *dragBar;
@property (nonatomic, weak) UILabel *placeNameLabel;
@property (nonatomic, weak) UIButton *starButton;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UIButton *showMoreButton;
@property (nonatomic, weak) UIImageView *showMoreImageView;
@property (nonatomic, weak) UIScrollView *imagesScrollView;

@end


@implementation CQUPTMapDetailView

- (instancetype)initWithPlaceItem:(CQUPTMapPlaceItem *)placeItem
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 20;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Map_backgroundColor"];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }

        UIView *dragBar = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            dragBar.backgroundColor = [UIColor colorNamed:@"Map_DetailDragColor"];
        } else {
            dragBar.backgroundColor = [UIColor colorWithHexString:@"#E1EDFB"];
        }
        [self addSubview:dragBar];
        self.dragBar = dragBar;
        
        UILabel *placeNameLabel = [[UILabel alloc] init];
        placeNameLabel.text = placeItem.placeName;
        placeNameLabel.font = [UIFont fontWithName:PingFangSCBold size:23];
        if (@available(iOS 11.0, *)) {
            placeNameLabel.textColor = [UIColor colorNamed:@"Map_TextColor"];
        } else {
            placeNameLabel.textColor = [UIColor colorWithHexString:@"#15305B"];
        }
        [self addSubview:placeNameLabel];
        self.placeNameLabel = placeNameLabel;
        
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [starButton setImage:[UIImage imageNamed:@"Map_StarButton"] forState:UIControlStateNormal];
        [self addSubview:starButton];
        self.starButton = starButton;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"详情";
        detailLabel.font = [UIFont fontWithName:PingFangSCBold size:17];
        if (@available(iOS 11.0, *)) {
            detailLabel.textColor = [UIColor colorNamed:@"Map_TextColor"];
        } else {
            detailLabel.textColor = [UIColor colorWithHexString:@"#15305C"];
        }
        [self addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        UIButton *showMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [showMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        showMoreButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        if (@available(iOS 11.0, *)) {
            [showMoreButton setTitleColor:[UIColor colorNamed:@"Map_SearchClearColor"] forState:UIControlStateNormal];
        } else {
            [showMoreButton setTitleColor:[UIColor colorWithHexString:@"ABBCD8"] forState:UIControlStateNormal];
        }
        [self addSubview:showMoreButton];
        self.showMoreButton = showMoreButton;
        
        UIImageView *showMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Map_ShowMore"]];
        [self addSubview:showMoreImageView];
        self.showMoreImageView = showMoreImageView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor grayColor];
        [self addSubview:scrollView];
        self.imagesScrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dragBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.centerX.equalTo(self);
        make.width.equalTo(@28);
        make.height.equalTo(@7);
    }];
    self.dragBar.layer.cornerRadius = 3.5;
    
    [self.placeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(40);
    }];
    
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-14);
        make.top.equalTo(self).offset(54);
        make.width.height.equalTo(@21);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self.placeNameLabel.mas_bottom).offset(49);
    }];

    [self.showMoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.detailLabel);
        make.width.equalTo(@5);
        make.height.equalTo(@11);
    }];
    
    [self.showMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLabel);
        make.trailing.equalTo(self.showMoreImageView.mas_leading).offset(-8);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [self.imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self).offset(15);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.height.equalTo(@157);
    }];
}

- (void)loadDataWithPlaceDetailItem:(CQUPTMapPlaceDetailItem *)detailItem {
    
}

@end
