//
//  SearchTopView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchTopView.h"
@interface SearchTopView()
/// 计时器
@property (nonatomic, strong) NSTimer *timer;

/// 用于秒数计时
@property (nonatomic) int second;

/// 用于轮播的序数
@property (nonatomic, assign) int i;


@end
@implementation SearchTopView
#pragma mark- life Cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        self.searchTextfield.placeholder = [NSString stringWithFormat:@"大家都在搜%@",self.placeholderArray[0]];
        //设置placeholder轮播
        self.second = 0;
        self.i = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cycle) userInfo:nil repeats:YES];
        
        [self buildFrame];
        
    }
    return self;
}

/// 将这些控件添加到屏幕上并为这些控件设置布局
- (void)buildFrame{
    
    //返回按钮。
        //在这里按钮和图标分开，按钮透明，实际范围比图标大
//    self.backBtn.backgroundColor = [UIColor redColor];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
//        make.width.mas_equalTo(MAIN_SCREEN_W * 0.06133);
        make.width.mas_equalTo(MAIN_SCREEN_W * 0.1);
    }];
        //返回的图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeCenter;    //设置图片不被拉伸压缩
    imageView.clipsToBounds = YES;  //让图片超过图片框的frame的部分隐藏
    imageView.image = [UIImage imageNamed:@"返回的小箭头"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0427);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.0186, 2 *MAIN_SCREEN_W * 0.0186 ));
    }];
    
    
    //搜索视图
        //1.添加背景view到屏幕上并设置布局
    [self addSubview:self.searchFieldBackgroundView];
    [self.searchFieldBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.backBtn.mas_right).offset(MAIN_SCREEN_W * 0.0693);
        make.right.equalTo(self.mas_right).offset(-MAIN_SCREEN_W * 0.0426);
    }];
        //2.添加搜索图标
    [self.searchFieldBackgroundView addSubview:self.searchIcon];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchFieldBackgroundView.mas_left).offset(MAIN_SCREEN_W * 0.0453);
        make.centerY.mas_equalTo(self.searchFieldBackgroundView.centerY);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.0533, MAIN_SCREEN_W * 0.0533));
    }];
        //3.添加搜索框
    [self.searchFieldBackgroundView addSubview:self.searchTextfield];
    [self.searchTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).offset(MAIN_SCREEN_W * 0.032);
        make.right.equalTo(self.searchFieldBackgroundView.mas_right).offset(-10);
        make.centerY.equalTo(self.searchFieldBackgroundView);
    }];
}

#pragma mark- evet response

/// 循环轮播搜索框词组
- (void)cycle{
    self.second++;      //开始计时
    if (self.second % 3 == 0) {     //每3秒轮播一次内容
        self.i++;
        [UIView transitionWithView:self.searchTextfield
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"大家都在搜%@",self.placeholderArray[self.i]] attributes:
                @{NSForegroundColorAttributeName:self.searchTextfield.textColor,
                  NSFontAttributeName:self.searchTextfield.font
                     }];
            self.searchTextfield.attributedPlaceholder = attrString;
          } completion:nil];
        //以此不断循环轮播内容
        if (self.i == self.placeholderArray.count - 1) {
            self.i = -1;
        }
    }
}



#pragma mark- getter
- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        //添加方法，跳回返回界面
        [_backBtn addTarget:self.delegate action:@selector(jumpBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)searchIcon{
    if (_searchIcon == nil) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.image = [UIImage imageNamed:@"放大镜"];
        _searchIcon.contentMode = UIViewContentModeCenter;    //设置图片不被拉伸压缩
//        _searchIcon.clipsToBounds = YES;  //让图片超过图片框的frame的部分隐藏
    }
    return _searchIcon;
}

- (UITextField *)searchTextfield{
    if (_searchTextfield == nil) {
        _searchTextfield = [[UITextField alloc] init];
        //设置字体
        _searchTextfield.font = [UIFont fontWithName:PingFangSCMedium size:14];
        
            //字体颜色
        if (@available(iOS 11.0, *)) {
            _searchTextfield.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#8796AB" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
            
        } else {
            // Fallback on earlier versions
        }
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"大家都在搜红岩" attributes:
            @{NSForegroundColorAttributeName:_searchTextfield.textColor,
              NSFontAttributeName:_searchTextfield.font
                 }];
        _searchTextfield.attributedPlaceholder = attrString;
    }
    return _searchTextfield;
}

- (UIView *)searchFieldBackgroundView{
    if (_searchFieldBackgroundView == nil) {
        _searchFieldBackgroundView = [[UIImageView alloc] init];
        _searchFieldBackgroundView.image = [UIImage imageNamed:@"搜索框背景图"];
        _searchFieldBackgroundView.userInteractionEnabled = YES;
    }
    return _searchFieldBackgroundView;
}

- (NSArray *)placeholderArray{
    if (_placeholderArray == nil || _placeholderArray.count == 0) {
        _placeholderArray = @[@"红岩",@"考研",@"啦啦操"];
    }
    return _placeholderArray;
}

@end
