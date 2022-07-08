//
//  IDMsgDisplayView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/11/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDMsgDisplayView.h"
#define YouSheBiaoTiHei @"YouSheBiaoTiHei"

@implementation IDMsgDisplayView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addBackImgView];
        [self addDepartmentLabel];
        [self addPositionLabel];
        [self addValidTimeLabel];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)addBackImgView {
    UIImageView *imgView = [[UIImageView alloc] init];
    //  @"IDCardCut"   @"身份卡片"
    self.backImgView = imgView;
    //??DEBUG
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    //??
    [self addSubview:imgView];
    
    imgView.layer.cornerRadius = 8;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addDepartmentLabel {
    UILabel *label = [[UILabel alloc] init];
    self.departmentLabel = label;
    [self addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:25];
    label.textColor = RGBColor(243, 254, 255, 1);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.064*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.04266666667*SCREEN_WIDTH);
    }];
//    label.text = @"红岩网校工作站";
}

- (void)addPositionLabel {
    UILabel *label = [[UILabel alloc] init];
    self.positionLabel = label;
    [self addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:20];
    label.textColor = RGBColor(212, 252, 255, 1);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.064*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.152*SCREEN_WIDTH);
    }];
//    label.text = @"干事";
}

- (void)addValidTimeLabel {
    UILabel *label = [[UILabel alloc] init];
    self.validTimeLabel = label;
    [self addSubview:label];
    
    label.font = [UIFont fontWithName:YouSheBiaoTiHei size:20];
    label.textColor = RGBColor(232, 253, 255, 1);

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.328*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.2373333333*SCREEN_WIDTH);
    }];
//    label.text = @"2020.8.6-2022.8.7";
}

- (void)setModel:(IDModel *)model {
    _model = model;
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:model.bgImgURLStr] placeholderImage:nil options:SDWebImageRefreshCached];
    self.positionLabel.text = model.positionStr;
    self.departmentLabel.text = model.departmentStr;
    self.validTimeLabel.text = model.validDateStr;
    self.backImgView.backgroundColor = model.color;
    //++++++++++++++++++debug++++++++++++++++++++  Begain
//#ifdef DEBUG
//    if (model.islate) {
//        self.backImgView.alpha = 0.4;
//        self.backgroundColor = [UIColor blackColor];
//    }else {
//        self.backImgView.alpha = 1;
//        self.backgroundColor = [UIColor clearColor];
//    }
//#endif
    //++++++++++++++++++debug++++++++++++++++++++  End
}
@end
