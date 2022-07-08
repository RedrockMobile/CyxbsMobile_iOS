//
//  IDCardTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/1.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPIDCardTableViewCell.h"


//开启CCLog
#define CCLogEnable 1

#define button_width 150.0 / 375 * SCREEN_WIDTH


@interface PMPIDCardTableViewCell ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton * settingButton;

@property (nonatomic, strong) UIButton * deleteButton;

@end

@implementation PMPIDCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self.contentView addSubview:self.containerScrollView];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.containerScrollView addSubview:self.idMsgView];
    [self.self.idMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.height.width.mas_equalTo(self.containerScrollView);
    }];
    
    [self.containerScrollView addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.mas_equalTo(self.containerScrollView);
        make.width.mas_equalTo(button_width);
        make.left.mas_equalTo(self.idMsgView.mas_right);
    }];
    
    [self.containerScrollView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.mas_equalTo(self.containerScrollView);
        make.width.mas_equalTo(button_width);
        make.left.mas_equalTo(self.settingButton.mas_right);
        make.right.mas_equalTo(self.containerScrollView.mas_right);
    }];
}

- (void)setModel:(IDModel *)model {
    self.idMsgView.model = model;
}

- (IDModel *)model {
    return self.idMsgView.model;
}

#pragma mark - action

- (void)settingButtonClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(settingButtonDidClicked:)]) {
        [self.delegate settingButtonDidClicked:button];
        [self.containerScrollView scrollToLeft];
    }
}

- (void)deleteButtonClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(deleteButtonDidClicked:cell:)]) {
        [self.delegate deleteButtonDidClicked:button cell:self];
        [self.containerScrollView scrollToLeft];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->x < scrollView.contentOffset.x) {
        [scrollView scrollToLeft];
    } else {
        [scrollView scrollToRight];
    }
}

#pragma mark -lazy

- (IDMsgDisplayView *)idMsgView {
    if (_idMsgView == NULL) {
        IDMsgDisplayView * view = [[IDMsgDisplayView alloc] init];
        _idMsgView = view;
    }
    return _idMsgView;
}

- (PMPGestureScrollView *)containerScrollView {
    if (_containerScrollView == NULL) {
        PMPGestureScrollView * view = [[PMPGestureScrollView alloc] init];
        view.pagingEnabled = true;
        view.showsVerticalScrollIndicator = false;
        view.showsHorizontalScrollIndicator = false;
        view.layer.cornerRadius = 8;
        view.backgroundColor = [UIColor systemRedColor];
        view.delegate = self;
        view.bounces = false;
        _containerScrollView = view;
    }
    return _containerScrollView;
}

- (UIButton *)settingButton {
    if (_settingButton == NULL) {
        UIButton * button = [[UIButton alloc] init];
        button.backgroundColor = RGBColor(71, 74, 80, 1);
        button.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:20];
        [button setTitle:@"设置"
                forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"Pmp_Setting"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(settingButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        _settingButton = button;
    }
    return _settingButton;
}

- (UIButton *)deleteButton {
    if (_deleteButton == NULL) {
        UIButton * button = [[UIButton alloc] init];
        button.backgroundColor = RGBColor(237, 83, 92, 1);
        
        button.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:20];
        [button setTitle:@"删除"
                forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"Pmp_Delete"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        _deleteButton = button;
    }
    return _deleteButton;
}

@end
/*
 保存cell，来获取数据，是个错误的操作，因为，cell的复用机制，可能会导致数据错误。
 */
