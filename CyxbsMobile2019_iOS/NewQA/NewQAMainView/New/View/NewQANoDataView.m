//
//  NewQANoDataView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/10/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQANoDataView.h"

@implementation NewQANoDataView

- (instancetype)initWithNodataImage:(UIImage *)image AndText:(NSString *)text {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorNamed:@"QATABLENODATACOLOR"];
        _nodataImageView = [[UIImageView alloc] init];
        _nodataImageView.image = image;
        [self addSubview:_nodataImageView];
        [_nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(HScaleRate_SE * 72);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(HScaleRate_SE * 144);
            make.width.mas_equalTo(WScaleRate_SE * 189);
        }];
        
        UILabel *nodataLabel = [[UILabel alloc] init];
        nodataLabel.text = text;
        nodataLabel.textAlignment = NSTextAlignmentCenter;
        nodataLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
        nodataLabel.textColor = [UIColor colorNamed:@"CellDetailColor"];
        [self addSubview:nodataLabel];
        [nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataImageView.mas_bottom).mas_offset(HScaleRate_SE * 10);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(HScaleRate_SE * 17);
            make.width.mas_equalTo(self);
        }];
    }
    return self;
}

@end
