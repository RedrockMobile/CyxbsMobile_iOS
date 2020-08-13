//
//  CQUPTMapBeforeSearchCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapBeforeSearchCell.h"

@interface CQUPTMapBeforeSearchCell ()

@property (nonatomic, weak) UIButton *deleteButton;

@end


@implementation CQUPTMapBeforeSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
        if (@available(iOS 11.0, *)) {
            titleLabel.textColor = [UIColor colorNamed:@"Map_SearchCellColor"];
        } else {
            titleLabel.textColor = [UIColor colorWithHexString:@"#234780"];
        }
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        // 这个图片在“Mine”里面
        [deleteButton setImage:[UIImage imageNamed:@"草稿箱垃圾桶"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(11);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(@17);
        make.width.equalTo(@16);
    }];
}


- (void)deleteButtonClicked {
    
}

@end
