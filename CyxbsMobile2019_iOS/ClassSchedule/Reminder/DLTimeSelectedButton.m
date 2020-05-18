//
//  DLTimeSelectedButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLTimeSelectedButton.h"


#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
@interface DLTimeSelectedButton ()
@property (nonatomic, strong) UIImageView *image;
@end

@implementation DLTimeSelectedButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@".PingFang SC-Semibold" size:15*kRateX];
        self.layer.masksToBounds = NO;
        self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reminderDeleteImage"]];
        [self addSubview: self.image];
    }
    return self;
}

- (void)initImageConstrains{
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(17*kRateX);
        make.height.mas_equalTo(17*kRateX);
    }];
    self.image.layer.cornerRadius = 8.5*kRateX;
    self.image.layer.masksToBounds = YES;
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickDeleteimage)];
//    [self.image addGestureRecognizer: tap];
}

//- (void)didClickDeleteimage{
//    [self.delegate deleteButtonWithTag:self.tag];
//    [self removeFromSuperview];
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    //首先调用父类的方法确定点击的区域确实在按钮的区域中
    BOOL res = [super pointInside:point withEvent:event];
    if (res) {
        CGRect btnBounds = self.bounds;
        //扩大点击区域，想缩小就将-10设为正值
        btnBounds = CGRectInset(btnBounds, 17, 17);
        if (CGRectContainsPoint(btnBounds, point)) {
            //如果在path区域内，可以接收交互事件，从而截获父视图的点击事件
//            self.userInteractionEnabled = YES;
            return YES;
        } else {
            [self.delegate deleteButtonWithTag:self.tag];
            [self removeFromSuperview];
            return NO;
        }
    }
    return NO;
}

@end
