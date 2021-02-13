//
//  SZHPhotoImageView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHPhotoImageView.h"

@implementation SZHPhotoImageView
- (instancetype)init{
    self = [super init];
    if (self) {
        //设置图片框可与用户进行交互，如果不设置，那么button无法被点击
        self.userInteractionEnabled = YES;
        self.clearBtn = [[UIButton alloc] init];
        [self.clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [self.clearBtn setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        //设置圆角
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)clear{
    [self.delegate clearPhotoImageView:self];
}

@end
