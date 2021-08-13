//
//  DiscoverTodoTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoTableViewCell.h"

@interface DiscoverTodoTableViewCell ()

/// 右侧的圆形复选框
@property(nonatomic, strong)UIButton* checkMarkBtn;

/// 事项标题
@property(nonatomic, strong)UILabel* titleLabel;

/// 铃铛按钮
@property(nonatomic, strong)UIImageView* bellImgView;

/// 提醒时间label
@property(nonatomic, strong)UILabel* notiTimeLabel;
@end

@implementation DiscoverTodoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCheckMarkBtn];
        [self addTitleLabel];
        self.bellImgView.alpha = 1;
        self.notiTimeLabel.alpha = 1;
        self.titleLabel.text = @"回家吃饭，回家吃饭，回家吃饭，回家吃饭";
        self.notiTimeLabel.text = @"2019.07.01";
    }
    return self;
}

- (void)addCheckMarkBtn {
    UIButton* btn = [[UIButton alloc] init];
    self.checkMarkBtn = btn;
    [self.contentView addSubview:btn];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"checkMarkCircle"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"todo已完成勾"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(checkMarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTitleLabel {
    UILabel* label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:15];
    label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];

}

//MARK: - 懒加载
//因为有些事项，不需要提醒，所以选择懒加载
- (UIImageView*)bellImgView {
    if (_bellImgView==nil) {
        UIImageView* imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        _bellImgView = imgView;
        
        [imgView setImage:[UIImage imageNamed:@"todo提醒的小铃铛"]];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0.112*SCREEN_WIDTH);
            make.top.equalTo(self.checkMarkBtn.mas_bottom).offset(0.01231527094*SCREEN_HEIGHT);
            make.width.mas_equalTo(0.02933333333*SCREEN_WIDTH);
            make.height.mas_equalTo(0.03466666667*SCREEN_WIDTH);
        }];
    }
    return _bellImgView;
}
- (UILabel*)notiTimeLabel {
    if (_notiTimeLabel==nil) {
        UILabel* label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _notiTimeLabel = label;
        
        label.font = [UIFont fontWithName:PingFangSCMedium size:11];
        label.textColor = [UIColor colorNamed:@"color21_49_91_&#F2F4FF"];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bellImgView.mas_right).offset(0.016*SCREEN_WIDTH);
            make.centerY.equalTo(self.bellImgView);
        }];
    }
    return _notiTimeLabel;
}

/// 点击复选框后调用，修改是否已完成的状态，连带改变UI效果
- (void)checkMarkBtnClicked {
    self.checkMarkBtn.selected = !self.checkMarkBtn.isSelected;
    NSDictionary* dict;
    double alpha;
    if (self.checkMarkBtn.selected) {
        alpha = 0.4;
        dict = @{
            NSStrikethroughStyleAttributeName:@1
        };
    }else {
        alpha = 1;
        dict = @{
            NSStrikethroughStyleAttributeName:@0
        };
    }
    self.titleLabel.alpha = self.bellImgView.alpha = self.notiTimeLabel.alpha = alpha;
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:dict];
}

/// 完成部分UI布局，bellImgView、notiTimeLabel的布局在其对应的getter方法内
- (void)layoutSubviews {
    [self.checkMarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*SCREEN_WIDTH);
        make.width.height.mas_equalTo(0.04533333333*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.01231527094*SCREEN_HEIGHT);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkMarkBtn.mas_right).offset(0.02666666667*SCREEN_WIDTH);
        make.centerY.equalTo(self.checkMarkBtn);
        make.width.mas_equalTo(0.75*SCREEN_WIDTH);
    }];
}
@end
