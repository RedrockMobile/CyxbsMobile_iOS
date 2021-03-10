//
//  ArticleTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self remakeFunBtnUI];
    }
    return self;
}

/// 把右上角的三个点点按钮的图标更换为垃圾桶图标，同时改一下大小
- (void)remakeFunBtnUI {
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"我的草稿箱垃圾桶"] forState:UIControlStateNormal];
    [self.funcBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*0.048);
        make.height.mas_equalTo(SCREEN_WIDTH*0.0533);
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
