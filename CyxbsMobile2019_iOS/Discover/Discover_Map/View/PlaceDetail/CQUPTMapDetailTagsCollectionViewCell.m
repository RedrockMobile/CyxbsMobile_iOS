//
//  CQUPTMapDetailTagsCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapDetailTagsCollectionViewCell.h"

@implementation CQUPTMapDetailTagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *taglabel = [[UILabel alloc] init];
        taglabel.font = [UIFont fontWithName:PingFangSCMedium size:13];
        taglabel.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 11.0, *)) {
            taglabel.textColor = [UIColor colorNamed:@"Map_SearchCellColor"];
        } else {
            taglabel.textColor = [UIColor colorWithHexString:@"234780"];
        }
        taglabel.layer.cornerRadius = 11;
        taglabel.layer.borderWidth = 1;
        taglabel.layer.borderColor = taglabel.textColor.CGColor;
        [self.contentView addSubview:taglabel];
        self.tagLabel = taglabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
