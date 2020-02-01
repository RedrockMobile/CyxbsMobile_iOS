//
//  HistoryView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "HistoryView.h"
#define SPLIT 7//item间距
#define LINESPLIT 10//行间距
@interface HistoryView()
@end
@implementation HistoryView
- (instancetype)initWithFrame:(CGRect)frame button:(UIButton *)exampleButton dataArray:(NSMutableArray *)dataArray {
    if(self = [super init]){
        self.exampleButton = exampleButton;
        self.dataArray = dataArray;
        self.frame = frame;
    }
    
    [self addItems];
    return self;
}
- (void) addItems {
    //遍历数组为每一个数据创建一个Label
    NSMutableArray <UIButton*>*buttonArray = [NSMutableArray array];
    self.buttonArray = buttonArray;
    NSLog(@"我收到的数组是%@",self.dataArray);
    for (NSString *text in self.dataArray) {
        UIButton *button = [[UIButton alloc]init];
        //对exampleButton进行监听
        [button.titleLabel setFont:self.exampleButton.titleLabel.font];
        [button setTitleColor:self.exampleButton.titleLabel.textColor forState:normal];
        button.backgroundColor = self.exampleButton.backgroundColor;
        button.layer.cornerRadius = self.exampleButton.layer.cornerRadius;
        [button setTitle:text forState:normal];
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }

}
- (void)layoutSubviews {
    
    //MARK: - 所有按钮的约束部分
    for (int i = 0; i < _buttonArray.count; i++) {
        [self.buttonArray[i].titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.buttonArray[i]).offset(15);
            make.right.equalTo(self.buttonArray[i]).offset(-15);
            make.centerY.equalTo(self.buttonArray[i]);
        }];
            if(i == 0){
                [_buttonArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.equalTo(self);
                    }];
    //                NSLog(@"正在约束第一个");
            } else if(i == 1){
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.buttonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.top.equalTo(self.buttonArray[0]);
                         make.left.equalTo(self.buttonArray[0].mas_right).offset(SPLIT);
                       }];
                     
                 });
            } else {//除了前两个以外，剩下的先用上一个估计能否放得下，不能就换行
    //                NSLog(@"正在约束第%d个",i);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self layoutIfNeeded];
//                        NSLog(@"数据是%f",self.buttonArray[i-1].frame.origin.x + self.buttonArray[i-1].frame.size.width*2);
                        if(self.buttonArray[i-1].frame.origin.x + self.buttonArray[i-1].frame.size.width*2 > self.width) {
                            [self.buttonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(self.buttonArray[i-1].mas_bottom).offset(LINESPLIT);
                                make.left.equalTo(self.buttonArray[0]);
                            }];
                        }else {
                            [self.buttonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.buttonArray[i-1].mas_right).offset(SPLIT);
                                make.top.equalTo(self.buttonArray[i-1]);
                            }];
                        }
                    });
                    
                }
        }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
