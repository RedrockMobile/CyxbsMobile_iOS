//
//  TopBarScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TopBarScrollView.h"
#import "DateModle.h"
@interface TopBarScrollView()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *weekChooseBar;
@property (nonatomic,strong)UIScrollView *nowWeekBar;
@property (nonatomic,strong)DateModle *dateModel;

@end

@implementation TopBarScrollView
- (instancetype)init{
    /**
    for (int i=0; i<26; i++) {
        
    
    if(self.dateModel.nowWeek.integerValue==i){
                    //显示本周的那个label
                    UILabel *nowWeekLabel = [[UILabel alloc] init];
                    [titleView addSubview: nowWeekLabel];
                    nowWeekLabel.text = @"(本周)";
    //                nowWeekLabel.backgroundColor = UIColor.redColor;
                    nowWeekLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
                    nowWeekLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
                    nowWeekLabel.frame = CGRectMake(MAIN_SCREEN_W*0.2627, 0.009*MAIN_SCREEN_H, 0.12*MAIN_SCREEN_W, 0.0259*MAIN_SCREEN_H);
                    
                    
                    UIButton *rightArrayBtn = [[UIButton alloc] init];
                    [titleView addSubview:rightArrayBtn];
                    [rightArrayBtn setTitle:@">" forState:(UIControlStateNormal)];
                    rightArrayBtn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
                    [rightArrayBtn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:(UIControlStateNormal)];

                    [rightArrayBtn setFrame:(CGRectMake(MAIN_SCREEN_W*0.3827, 3, 7, MAIN_SCREEN_H*0.0391))];
                    
                    
                    [rightArrayBtn addTarget:self action:@selector(rightArrayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    NSArray *a = @[nowWeekLabel,rightArrayBtn,titleLabel];
                    [viewArray addObject:a];
                }else{
                    //(MAIN_SCREEN_W*0.0427, 0, MAIN_SCREEN_W*0.22, MAIN_SCREEN_H*0.0391)
                    UIButton *rightArrayBtn = [[UIButton alloc] init];
                    [titleView addSubview:rightArrayBtn];
                    [rightArrayBtn setTitle:@">" forState:(UIControlStateNormal)];
                    rightArrayBtn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
                    [rightArrayBtn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:(UIControlStateNormal)];
                    [rightArrayBtn setFrame:(CGRectMake(MAIN_SCREEN_W*0.2627, 3, 7, MAIN_SCREEN_H*0.0391))];
                    [rightArrayBtn addTarget:self action:@selector(rightArrayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    UIButton *backBtn = [[UIButton alloc] init];
                    [titleView addSubview:backBtn];
                    [backBtn setTitle:@"回到本周" forState:(UIControlStateNormal)];
                    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    [backBtn setBackgroundColor:[UIColor colorWithRed:41/255.0 green:33/255.0 blue:209/255.0 alpha:1.0]];
                    backBtn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 13];
                    backBtn.layer.cornerRadius = MAIN_SCREEN_H*0.0197;
                    [backBtn setFrame:(CGRectMake(MAIN_SCREEN_W*0.728, 0, 0.2293*MAIN_SCREEN_W, 0.0394*MAIN_SCREEN_H))];

                    [backBtn addTarget:self action:@selector(backNowWeekBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    NSArray *a = @[rightArrayBtn,backBtn,titleLabel];
                    [viewArray addObject:a];
                }
        
    }
     */
    return self;
}

- (void)addNowWeekBar{
    
}
@end
