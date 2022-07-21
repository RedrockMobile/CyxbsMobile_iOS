//
//  IDCardTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/1.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "IDCardTableViewCell.h"


//开启CCLog
#define CCLogEnable 1

@interface IDCardTableViewCell ()
@end

@implementation IDCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addIdMsgView];
    }
    return self;
}

- (void)addIdMsgView {
    IDMsgDisplayView *view = [[IDMsgDisplayView alloc] init];
    self.idMsgView = view;
    [self.contentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-0.05333333333*SCREEN_WIDTH);
    }];
}

- (void)setModel:(IDModel *)model {
    self.idMsgView.model = model;
}

- (IDModel *)model {
    return self.idMsgView.model;
}



@end
/*
 保存cell，来获取数据，是个错误的操作，因为，cell的复用机制，可能会导致数据错误。
 */
