//
//  TimeSelectedBtnsView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/19.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TimeSelectedBtnsView.h"
#import "DLTimeSelectedButton.h"

/// 显示已经选择过的那些时间段的view
@interface TimeSelectedBtnsView()<DLTimeSelectedButtonDelegate>

/// 显示@“时间选择”的第一个按钮
@property(nonatomic,strong)UIButton *timeSelctbtn;

/// 放按钮的数组
@property(nonatomic,strong)NSMutableArray *timebuttonArray;

@end

@implementation TimeSelectedBtnsView
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/// 添加显示@“时间选择”的第一个按钮
- (void)AddTimeSelctbtn{
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.timeSelctbtn = btn;
    
    [btn setTitle:@"备忘周" forState:UIControlStateNormal];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W*0.0534);
        make.width.mas_equalTo(MAIN_SCREEN_W*0.2267);
        make.height.mas_equalTo(MAIN_SCREEN_W*0.104);
        make.top.equalTo(self);
    }];
    
    
}
- (void)addBtnWithString:(NSString*)str{
    
}
//@{@"weekString":@"",  @"lessonString":@""}
- (void)reloadSelectedButtonsWithTimeStringArray:(NSArray*)timeDictArray{
    for (UIButton *btn in self.timebuttonArray) {
        [btn removeFromSuperview];
    }
    
    self.timebuttonArray = [@[] mutableCopy];
    
    self.delegate.timeDictArray = [timeDictArray mutableCopy];
    
    float row = 0.0,line;
    NSInteger count = timeDictArray.count;
    UIView *leftBtn;
    for (NSInteger i = 0; i < count; i++) {
        row = i/2;
        line = i%2;
        
        DLTimeSelectedButton *button = [[DLTimeSelectedButton alloc] init];
        NSDictionary *timeDict = timeDictArray[i];
        NSString *timeStr = [NSString stringWithFormat:@"%@   %@",timeDict[@"weekString"],timeDict[@"lessonString"]];
        
        [button setTitle:timeStr forState:UIControlStateNormal];
        button.tag = i;
        [self addSubview: button];
        if(line==0){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(row*0.1573*MAIN_SCREEN_W);
                make.left.equalTo(self).offset(MAIN_SCREEN_W*0.0427);
                make.height.mas_equalTo(MAIN_SCREEN_W*0.104);
            }];
        }else{
            leftBtn = [self.timebuttonArray lastObject];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(row*0.1573*MAIN_SCREEN_W);
                make.left.equalTo(leftBtn.mas_right).offset(MAIN_SCREEN_W*0.0427);
                make.height.mas_equalTo(MAIN_SCREEN_W*0.104);
            }];
        }
        
        [button.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(0.0427*MAIN_SCREEN_W);
            make.right.equalTo(button).offset(-0.0427*MAIN_SCREEN_W);
        }];
        
        [button initImageConstrains];
        button.delegate = self;
        [self.timebuttonArray addObject:button];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(row*0.1573*MAIN_SCREEN_W+MAIN_SCREEN_W*0.104);
    }];
}
- (void)deleteButtonWithTag:(NSInteger)tag{
    NSDictionary *deleteDict = self.delegate.timeDictArray[tag];
    [self.delegate.timeDictArray removeObject: deleteDict];
    [self reloadSelectedButtonsWithTimeStringArray:self.delegate.timeDictArray];
}

- (void)loadSelectedButtonsWithTimeDict:(NSDictionary*)timeDict{
    [self.delegate.timeDictArray addObject:timeDict];
    [self reloadSelectedButtonsWithTimeStringArray:self.delegate.timeDictArray];
}
@end
