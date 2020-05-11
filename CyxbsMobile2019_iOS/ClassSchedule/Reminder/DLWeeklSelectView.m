//
//  DLWeeklSelectView.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLWeeklSelectView.h"
#import "DLWeekButton.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准

@implementation DLWeeklSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
        } else {
             self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            // Fallback on earlier versions
        }
        self.layer.shadowColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.8].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowRadius = 30*kRateY;
        self.layer.shadowOpacity = 1;
        self.layer.cornerRadius = 16*kRateX;
        self.layer.masksToBounds = YES;
         [self initConfirmButton];
    }
    return self;
}
- (void) initConfirmButton{
    self.confirmBtn = [[UIButton alloc] init];
//    self.confirmBtn.frame = CGRectMake(130.0,728.0,120.0,40.0);
    self.confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(130.0,728.0,120.0,40.0);
    gl.startPoint = CGPointMake(0.3560017943382263, 0.8500478863716125);
    gl.endPoint = CGPointMake(4.006013870239258, -5.502598762512207);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:93/255.0 green:93/255.0 blue:247/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [self.confirmBtn.layer addSublayer:gl];
    self.confirmBtn.layer.cornerRadius = 16*kRateX;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn.titleLabel setTextColor: [UIColor whiteColor]];
    self.confirmBtn.titleLabel.font = [UIFont fontWithName:@".PingFang SC-Medium" size:18*kRateX];
    self.confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.confirmBtn.titleLabel.frame = self.confirmBtn.frame;
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).mas_offset(-42*kRateY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(120*kRateX);
        make.height.mas_equalTo(40*kRateY);
    }];
    
}
- (void)setWeekArray:(NSArray *)weekArray{
    _weekArray = weekArray;
    [self initWeekButtons];
}

- (void)initWeekButtons{
    CGFloat hasOccupiedWidth = 16 * kRateX;
    NSInteger j = 0;
    NSInteger count = self.weekArray.count;
    for (NSInteger i = 0; i < count; i++) {
        CGSize size = [self.weekArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@".PingFang SC-Regular" size:12*kRateX]}];
        if (hasOccupiedWidth + size.width + 40*kRateX > SCREEN_WIDTH - 16*kRateX) {
            j++;
            hasOccupiedWidth = 16*kRateX;
        }
        DLWeekButton *button = [[DLWeekButton alloc] init];
        [button setTitle:self.weekArray[i] forState:UIControlStateNormal];
        [button setTitle:self.weekArray[i] forState:UIControlStateSelected];
        [button setTitle:self.weekArray[i] forState:UIControlStateSelected|UIControlStateHighlighted];
        button.tag = i;
        [button addTarget:self action:@selector(didClickWeekButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(22*kRateY + j*40*kRateY);
            make.left.equalTo(self.mas_left).mas_offset(hasOccupiedWidth + 10*kRateX);
            make.width.mas_equalTo(size.width + 24*kRateX);
            make.height.mas_equalTo(30*kRateX);
        }];
        hasOccupiedWidth += size.width + 34*kRateX;
    }
}
- (void)didClickWeekButton:(DLWeekButton *)button{
    button.selected = !button.selected;
    button.isChangeColor = !button.isChangeColor;
    if (button.selected) {
        [self.delegate selectedWeekArrayAtIndex:button.tag];
    }
}
@end
