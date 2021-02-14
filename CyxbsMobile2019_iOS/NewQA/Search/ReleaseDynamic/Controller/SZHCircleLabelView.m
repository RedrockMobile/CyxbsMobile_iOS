//
//  SZHCircleLabelView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/14.
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
            //设置滑动区域
        self.contentSize = CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.75);
            //隐藏滑动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        //添加控件
        [self addLabelAndView];
        
        [self addButtonsWithArray:array];
        
        [self btnsAddConstraints];
    }
    return self;
}

/// 添加label和分割view
- (void)addLabelAndView{
    //分割view
    self.topSeparationView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.topSeparationView.backgroundColor = [UIColor colorNamed:@"SZH分割条颜色"];
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
    self.tittleLbl.text = @"请选择圈子";
    if (@available(iOS 11.0, *)) {
        self.tittleLbl.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
    } else {
        // Fallback on earlier versions
    }
    self.tittleLbl.font = [UIFont fontWithName:@"PingFangSC-Bold" size:15];
    [self addSubview:self.tittleLbl];
    [self.tittleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self.topSeparationView.mas_bottom).offset(MAIN_SCREEN_H * 0.0292);
    }];
}

/// 添加按钮
- (void)addButtonsWithArray:(NSArray *)array{
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        CircleLabelBtn *button = [[CircleLabelBtn alloc] init];
        //设置文本
        [button setTitle:[NSString stringWithFormat:@"# %@",array[i]] forState:UIControlStateNormal];
        button.tag = 100 + i;      //设置每个button的tag
        [button addTarget:self action:@selector(changeBtnState:) forControlEvents:UIControlEventTouchUpInside];
        if (@available(iOS 11.0, *)) {
            [button setTitleColor:[UIColor colorNamed:@"圈子标签按钮未选中时文本颜色"] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
    
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonArray.count == 0) return;
    __block int k = 0;
    [self.buttonArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tittleLbl.mas_bottom).offset(MAIN_SCREEN_W * 0.0413);
        make.left.equalTo(self.tittleLbl);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.0382);
    }];
    __block float lastBtnW,lastBtnX;
    for (int i = 1; i < self.buttonArray.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutIfNeeded];
            lastBtnW = self.buttonArray[i-1].frame.size.width;
            lastBtnX = self.buttonArray[i-1].frame.origin.x;
            if(lastBtnX + lastBtnW*2 > self.frame.size.width) {
                k++;
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tittleLbl.mas_bottom).offset(k * MAIN_SCREEN_W*0.1147 + self.split);
                    make.left.equalTo(self.tittleLbl);
                }];
            }else {
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.tittleLbl).offset(self.split + lastBtnW + lastBtnX);
                    make.top.equalTo(self.tittleLbl.mas_bottom).offset(k * MAIN_SCREEN_W*0.1147 + MAIN_SCREEN_W * 0.0413);
                }];
            }
        });
    }
}

- (void)changeBtnState:(UIButton *)sender{
    [self.delegate clickACirleBtn:sender];
}
@end
