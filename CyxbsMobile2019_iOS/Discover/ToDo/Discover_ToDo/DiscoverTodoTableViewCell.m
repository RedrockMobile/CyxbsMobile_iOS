//
//  DiscoverTodoTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoTableViewCell.h"
#import "TodoSyncTool.h"
#import "DiscoverTodoTableViewAnimationView.h"

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
        self.backgroundColor = [UIColor colorNamed:@"TodoBG"];
    }
    return self;
}

- (void)setDataModel:(TodoDataModel *)dataModel {
    _dataModel = dataModel;
    self.notiTimeLabel.text = dataModel.overdueTimeStr;
    self.checkMarkBtn.selected = dataModel.isDone;
    self.titleLabel.text = dataModel.titleStr;
    [self setTodoState:dataModel.todoState];
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
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bellImgView.mas_right).offset(0.016*SCREEN_WIDTH);
            make.centerY.equalTo(self.bellImgView);
        }];
    }
    return _notiTimeLabel;
}

/// 点击复选框后调用，修改是否已完成的状态，连带改变UI效果
- (void)checkMarkBtnClicked {
    DiscoverTodoTableViewAnimationView *animationView = [[DiscoverTodoTableViewAnimationView alloc ] initWithCellFrame:self.contentView.frame labelFrame:self.titleLabel.frame];
    [self.contentView addSubview:animationView];
    self.checkMarkBtn.alpha = 0;
    [animationView begainAnimationWithCompletionBlock:^{
        self.checkMarkBtn.alpha = 1;
        [self.dataModel setIsDoneForUserActivity:!self.dataModel.isDone];
//        //通知DiscoverTodoView，开始动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverTodoTableViewCellCheckMarkBtnClicked" object:self];
    }];
}
- (void)setTodoState:(TodoDataModelState)state {
    NSDictionary* attributeDict;
    double titleAlpha, notiTimeAndBellAlpha;
    switch (state) {
        case TodoDataModelStateDone:
            titleAlpha = 0.4;
            notiTimeAndBellAlpha = 0.4;
            attributeDict = @{
                NSStrikethroughStyleAttributeName:@1,
                NSForegroundColorAttributeName:[UIColor colorNamed:@"color21_49_91&#F0F0F2"]
            };
            break;
        case TodoDataModelStateOverdue:
            titleAlpha = 1;
            notiTimeAndBellAlpha = 0;
            attributeDict = @{
                NSStrikethroughStyleAttributeName:@0,
                NSForegroundColorAttributeName:[UIColor redColor],
            };
            break;
        case TodoDataModelStateNeedDone:
            titleAlpha = 1;
            notiTimeAndBellAlpha = 1;
            attributeDict = @{
                NSStrikethroughStyleAttributeName:@0,
                NSForegroundColorAttributeName:[UIColor colorNamed:@"color21_49_91&#F0F0F2"],
            };
            break;
    }
    
    if ([self.dataModel.timeStr isEqualToString:@""]) {
        self.notiTimeLabel.alpha =
        self.bellImgView.alpha = 0;
        CCLog(@"%f, %f", self.notiTimeLabel.alpha, self.bellImgView.alpha);
    }else {
        self.notiTimeLabel.alpha =
        self.bellImgView.alpha = notiTimeAndBellAlpha;
        CCLog(@"%f, %f", self.notiTimeLabel.alpha, self.bellImgView.alpha);
    }
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributeDict];
    self.titleLabel.alpha = titleAlpha;
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
        make.width.mas_lessThanOrEqualTo(0.75*SCREEN_WIDTH);
    }];
}
@end
