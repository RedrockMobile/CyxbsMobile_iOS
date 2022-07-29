//
//  QASegementBarBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "QASegementBarBtn.h"
@interface QASegementBarBtn ()

@end
@implementation QASegementBarBtn
- (instancetype)initWithFrame:(CGRect)frame AndContent:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        btnLbl.text = content;
        btnLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        btnLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
        [self addSubview:btnLbl];
        [btnLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


@end
