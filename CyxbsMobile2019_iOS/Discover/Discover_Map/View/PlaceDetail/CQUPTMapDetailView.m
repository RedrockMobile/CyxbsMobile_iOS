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
@property (nonatomic, strong) NSMutableArray<UILabel *> *attributesLabelArray;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UIButton *showMoreButton;
@property (nonatomic, weak) UIImageView *showMoreImageView;
@property (nonatomic, weak) UIScrollView *imagesScrollView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imagesArray;
@property (nonatomic, weak) UIImageView *shareImageView;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UILabel *aboutHereLabel;

@end


@implementation CQUPTMapDetailView

- (instancetype)initWithPlaceItem:(CQUPTMapPlaceItem *)placeItem
{
    self = [super init];
    if (self) {
        self.attributesLabelArray = [NSMutableArray array];
        self.imagesArray = [NSMutableArray array];
        
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
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
    
    for (int i = 0; i < self.attributesLabelArray.count; i++) {
        if (i == 0) {
            [self.attributesLabelArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self).offset(15);
                make.top.equalTo(self.placeNameLabel.mas_bottom).offset(8);
                make.width.equalTo(@([self attributeLabelWidthText:self.attributesLabelArray[i].text] + 15));
                make.height.equalTo(@18);
            }];
        } else {
            [self.attributesLabelArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.attributesLabelArray[i - 1].mas_trailing).offset(12);
                make.centerY.equalTo(self.attributesLabelArray[i - 1]);
                make.width.equalTo(@([self attributeLabelWidthText:self.attributesLabelArray[i].text] + 15));
                make.height.equalTo(@18);
            }];
        }
    }
    
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
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.height.equalTo(@157);
    }];
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        if (i == 0) {
            [self.imagesArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.imagesScrollView);
                make.top.bottom.equalTo(self.imagesScrollView);
                make.height.equalTo(@157);
                make.width.equalTo(@280);
            }];
        } else if (i == self.imagesArray.count - 1) {
            [self.imagesArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.imagesArray[i - 1].mas_trailing).offset(14);
                make.top.bottom.equalTo(self.imagesScrollView);
                make.height.equalTo(@157);
                make.width.equalTo(@280);
                make.trailing.equalTo(self.imagesScrollView);
            }];
        } else {
            [self.imagesArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.imagesArray[i - 1].mas_trailing).offset(14);
                make.top.bottom.equalTo(self.imagesScrollView);
                make.height.equalTo(@157);
                make.width.equalTo(@280);
            }];
        }
    }
}

- (void)loadDataWithPlaceDetailItem:(CQUPTMapPlaceDetailItem *)detailItem {    
    for (int i = 0; i < detailItem.placeAttributesArray.count; i++) {
        
        NSString *placeAttribute = detailItem.placeAttributesArray[i];
                
        UILabel *attributeLabel = [[UILabel alloc] init];
        attributeLabel.text = placeAttribute;
        attributeLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        attributeLabel.layer.cornerRadius = 9;
        attributeLabel.layer.borderWidth = 1;
        attributeLabel.textAlignment = NSTextAlignmentCenter;
        attributeLabel.alpha = 0;
        if (@available(iOS 11.0, *)) {
            attributeLabel.textColor = [UIColor colorNamed:@"Map_StarLabelColor"];
        } else {
            attributeLabel.textColor = [UIColor colorWithHexString:@"778AA9"];
        }
        attributeLabel.layer.borderColor = attributeLabel.textColor.CGColor;
        [self addSubview:attributeLabel];
        [self.attributesLabelArray addObject:attributeLabel];
        
    }
    
    if (detailItem.imagesArray.count == 0) {
        UIImageView *placeImageView = [[UIImageView alloc] init];
        placeImageView.layer.cornerRadius = 9;
        placeImageView.clipsToBounds = YES;
        placeImageView.backgroundColor = [UIColor grayColor];
        [self.imagesScrollView addSubview:placeImageView];
        [self.imagesArray addObject:placeImageView];
    }
    
    for (int i = 0; i < detailItem.imagesArray.count; i++) {
        UIImageView *placeImageView = [[UIImageView alloc] init];
        [placeImageView sd_setImageWithURL:detailItem.imagesArray[i] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            placeImageView.contentMode = UIViewContentModeScaleAspectFill;
        }];
        placeImageView.layer.cornerRadius = 9;
        placeImageView.clipsToBounds = YES;
        [self.imagesScrollView addSubview:placeImageView];
        [self.imagesArray addObject:placeImageView];
    }
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        for (UILabel *attributeLabel in self.attributesLabelArray) {
            attributeLabel.alpha = 1;
        }
    }];
}

- (CGFloat)attributeLabelWidthText:(NSString *)text {
    NSDictionary *dic = @{NSFontAttributeName: [UIFont fontWithName:PingFangSCBold size:15]};

    CGRect rect = [text boundingRectWithSize:CGSizeMake(0, 10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];

    return rect.size.width;
}

@end
