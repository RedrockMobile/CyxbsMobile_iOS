//
//  SSRTopBarBaseView.m
//  SSRSwipe
//
//  Created by SSR on 2022/4/6.
//

#import "SSRTopBarBaseView.h"

#pragma mark - SSRTopBarBaseView ()

@interface SSRTopBarBaseView ()

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 标题Label
@property (nonatomic, strong, nullable) UILabel *titleLab;

@end

#pragma mark - SSRTopBarBaseView

@implementation SSRTopBarBaseView

#pragma mark - Init

- (instancetype)initWithSafeViewHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBARHEIGHT + height)];
    if (self) {
        [self addSubview:self.safeView]; {
            self.safeView.height = height;
            self.safeView.bottom = self.SuperBottom;
            
            [self.safeView addSubview:self.backBtn];
            self.backBtn.centerY = self.safeView.SuperCenter.y;
        }
    }
    return self;
}

#pragma mark - Method

- (void)addTitle:(NSString *)title
    withTitleLay:(SSRTopBarBaseViewTitleLabLay)titleLay
       withStyle:(void (^)(UILabel * _Nonnull))setTitleLab {
    // 如果以前有，那么就删掉
    if (_titleLab) {
        [self.titleLab removeFromSuperview];
        self.titleLab = nil;
    }
    // 先设置一个title，用于后面计算
    self.titleLab.text = title;
    // 先问block要，再去算
    if (setTitleLab) {
        setTitleLab(self.titleLab);
        title = self.titleLab.text;
    }
    // 算size，并确定最初布局
    CGSize size =
    [self.titleLab.text
     sizeWithAttributes:@{
        NSFontAttributeName : self.titleLab.font
    }];
    self.titleLab.size = size;
    self.titleLab.centerY = self.safeView.SuperCenter.y;
    // Lay
    switch (titleLay) {
        case SSRTopBarBaseViewTitleLabLayMiddle: {
            self.titleLab.center = self.safeView.SuperCenter;
            break;
        }
        case SSRTopBarBaseViewTitleLabLayLeft: {
            self.titleLab.left = self.backBtn.right + 6;
            break;
        }
    }
    
    [self.safeView addSubview:self.titleLab];
}

- (void)addBackButtonTarget:(id)target action:(SEL)action {
    [self.backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getter

- (UIView *)safeView {
    if (_safeView == nil) {
        // 高和顶部由父控件确定
        _safeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    }
    return _safeView;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
        _backBtn.layer.cornerRadius = 10;
        _backBtn.backgroundColor = [UIColor clearColor];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:PingFangSCSemibold size:22];
        _titleLab.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    }
    return _titleLab;
}

@end
