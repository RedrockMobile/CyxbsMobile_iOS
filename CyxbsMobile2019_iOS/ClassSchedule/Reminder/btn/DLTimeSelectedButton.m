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
        self.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:15];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 20;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(MAIN_SCREEN_W*0.03467);
            make.right.equalTo(self).offset(-MAIN_SCREEN_W*0.04267);
        }];
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
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    //首先调用父类的方法确定点击的区域确实在按钮的区域中
    BOOL res = [super pointInside:point withEvent:event];
    if (res) {
        //拿到叉的矩形区
        CGRect imgBound = self.image.bounds;
        
        //叉的矩形区宽高各加5，center不变
        imgBound = CGRectInset(imgBound, -10, -10);
        
        //转化为叉内的点
        CGPoint imgPoint = [self convertPoint:point toView:self.image];
        
        //判断是否在加5后的区域，如果是就删除
        if (CGRectContainsPoint(imgBound, imgPoint)) {
            [self.delegate deleteButtonWithTag:self.tag];
            [self removeFromSuperview];
            return YES;
        } else {
            return YES;
        }
    }
    return NO;
}

@end
