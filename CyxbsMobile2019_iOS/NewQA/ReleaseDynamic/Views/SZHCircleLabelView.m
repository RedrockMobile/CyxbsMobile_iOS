//
//  SZHCircleLabelView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/20.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHCircleLabelView.h"
#import "CircleLabelBtn.h"
@implementation SZHCircleLabelView
- (instancetype)initWithArrays:(NSArray *)array{
    self = [super init];
    if (self) {
        //关于一些自己的设置
        self.split = MAIN_SCREEN_W * 0.032;
        //添加控件
        [self addLabelAndView];
        
        [self addButtonsWithArray:array];
        
    }
    return self;
}

/// 添加label和分割view
- (void)addLabelAndView{
    //分割view
    self.topSeparationView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.topSeparationView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#252525" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
//    self.topSeparationView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.topSeparationView];
    [self.topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
    
    //标题alebl
    self.tittleLbl = [[UILabel alloc] init];
    self.tittleLbl.text = @"请选择一个圈子";
    if (@available(iOS 11.0, *)) {
        self.tittleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    self.tittleLbl.font = [UIFont fontWithName:PingFangSCBold size:15];
    [self addSubview:self.tittleLbl];
    [self.tittleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.04);
        make.top.equalTo(self.topSeparationView.mas_bottom).offset(MAIN_SCREEN_H * 0.0292);
    }];
}

/// 添加按钮
- (void)addButtonsWithArray:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        CircleLabelBtn *button = [[CircleLabelBtn alloc] init];
        //设置文本
        [button setTitle:[NSString stringWithFormat:@"# %@",array[i]] forState:UIControlStateNormal];
        button.tag = 100 + i;      //设置每个button的tag
        [button addTarget:self action:@selector(changeBtnState:) forControlEvents:UIControlEventTouchUpInside];
        if (@available(iOS 11.0, *)) {
            [button setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
    
    //进行布局约束
    [self btnsAddConstraints];
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonArray.count == 0){
        return;
    }
    [self.buttonArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tittleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.0292);
        make.left.equalTo(self.tittleLbl);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.0382);
    }];
    //立即得到masonry约束后的button的Frame，不用等到下一个runloop周期
    [self layoutIfNeeded];
    //初始的X、Y值
    CGFloat originX = self.buttonArray[0].frame.origin.x;
    CGFloat originY = self.buttonArray[0].frame.origin.y;
    //button间X、Y间距
    CGFloat space = MAIN_SCREEN_W * 0.0333;
    //button位置临界值判断变量
    CGFloat positionX = originX;
    CGFloat positionY = originY;
    
    CGFloat maxX = MAIN_SCREEN_W;   //最大X值
    for (int i = 1; i < self.buttonArray.count; i++) {
        //button的字符串宽度
        CGFloat titleWidth = [self.buttonArray[i].titleLabel.text boundingRectWithSize:CGSizeMake(1000, MAIN_SCREEN_H * 0.0382) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:12]} context:nil].size.width;
        //button宽度
        CGFloat buttonWidth = titleWidth + MAIN_SCREEN_W * 0.112;
        CGFloat buttonX = CGRectGetMaxX(self.buttonArray[i-1].frame) + space;
        positionX = CGRectGetMaxX(self.buttonArray[i-1].frame) + space + buttonWidth;
        if (positionX > maxX) {
            positionX = originX;
            buttonX = originX;
            positionY = positionY + MAIN_SCREEN_H * 0.0382 + space;
        }
        self.buttonArray[i].frame = CGRectMake(buttonX, positionY, buttonWidth, MAIN_SCREEN_H * 0.0382);
    }
}

- (void)updateViewWithAry:(NSArray *)array{
    [self addButtonsWithArray:array];
    [self btnsAddConstraints];
}

- (void)changeBtnState:(UIButton *)sender{
    [self.delegate clickACirleBtn:sender];
}

@end
