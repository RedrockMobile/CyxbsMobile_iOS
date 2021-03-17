//
//  ArticleTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//  动态页的cell

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self remakeFunBtnUI];
        [self addSeparateLine];
    }
    return self;
}

/// 把右上角的三个点点按钮的图标更换为垃圾桶图标，同时改一下大小
- (void)remakeFunBtnUI {
    [self.funcBtn setImage:nil forState:UIControlStateNormal];
    [self.funcBtn setBackgroundImage:[UIImage imageNamed:@"我的草稿箱垃圾桶"] forState:UIControlStateNormal];
    
    [self.funcBtn setImageEdgeInsets:UIEdgeInsetsZero];
    [self.funcBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(SCREEN_WIDTH * 0.89 * 18/343);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(SCREEN_WIDTH * 0.89);
        make.height.mas_equalTo(SCREEN_WIDTH*0.0533);
        make.width.mas_equalTo(SCREEN_WIDTH*0.048);
    }];
}

/// 添加 底部分隔线 的方法，为什么不用系统的分割线？为了避免在cell不足的情况下影响美观。
- (void)addSeparateLine{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"45_45_45_20&230_230_230_40"];
    } else {
        view.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:0.64];
    }
}




//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}

@end
