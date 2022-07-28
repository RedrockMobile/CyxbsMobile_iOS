//
//  SZHSearchTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHSearchTableViewCell.h"

@implementation SZHSearchTableViewCell
- (instancetype)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        self.string = string;
        self.textLabel.text = string;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)layoutSubviews{
    [self.contentView addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(6);
    }];
    
    [self.contentView addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.width.mas_equalTo(20);
    }];
}

#pragma mark- event response
- (void)touchDleteBtn{
    [self.delegate deleteHistoryCellThroughString:self.string];
}

#pragma mark- getter
- (UILabel *)textLabel{
    if (_textLbl == nil) {
        _textLbl = [[UILabel alloc] init];
        _textLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        if (@available(iOS 11.0, *)) {
            _textLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#60718D" alpha:1] darkColor:[UIColor colorWithHexString:@"#838484" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return _textLbl;
}

- (UIButton *)clearBtn{
    if (_clearBtn == nil) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setImage:[UIImage imageNamed:@"垃圾箱图标"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(touchDleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}
@end
