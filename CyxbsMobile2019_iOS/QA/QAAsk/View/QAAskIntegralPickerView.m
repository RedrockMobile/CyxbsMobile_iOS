//
//  QAAskIntegralPickerView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskIntegralPickerView.h"

@implementation QAAskIntegralPickerView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
    }
    [self setupView];
    return self;
}
-(void)setupView{
    self.integralPickView.transform = CGAffineTransformMakeRotation(M_PI*3/2);
    [self.integralPickView setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    self.integralNum = @"0";
    self.integralPickViewContent = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSString *numString = [NSString stringWithFormat:@"%d",i];
        [self.integralPickViewContent addObject:numString];
    }
}
#pragma mark - UIPickerViewDelegate
#pragma mark 列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
#pragma mark 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.integralPickViewContent.count;
}

#pragma mark pickerView内容
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.text = self.integralPickViewContent[row];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"Impact" size:64]];
    label.textColor = [UIColor colorWithHexString:@"#2A4E84"];
    return label;
}
#pragma mark pickerView每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 80;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 100;
}
#pragma mark pickerView滚动方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.integralNum = self.integralPickViewContent[row];
    NSLog(@"%@",self.integralNum);
    
}

@end
