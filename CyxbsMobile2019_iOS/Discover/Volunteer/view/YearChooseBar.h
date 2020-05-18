//
//  YearChooseBar.h
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/31.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearChooseBar : UIView

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger index;
-(instancetype)initWithFrame:(CGRect)frame nowYear:(NSNumber *)nowYear;
-(void)changeIndex:(NSInteger)index;

@end
