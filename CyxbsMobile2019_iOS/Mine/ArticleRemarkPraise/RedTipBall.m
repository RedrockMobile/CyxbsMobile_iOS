//
//  RedTipBall.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//  小红点

#import "RedTipBall.h"
#define ballDiameter  (SCREEN_WIDTH*0.0427)
#define ballDiameter99  (SCREEN_WIDTH*0.0707)

@interface RedTipBall()
/// 最开始的位置，只初始化一次
@property(nonatomic,assign)CGPoint originCenter;
@property(nonatomic,strong)UILabel *msgLabel;
@end
@implementation RedTipBall
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 0.5*ballDiameter;
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(ballDiameter);
//        }];
        self.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:184/255.0 alpha:1];
        UIPanGestureRecognizer *PGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ballMove:)];
        [self addGestureRecognizer:PGR];
        [self addMsgLabel];
    }
    return self;
}

- (void)ballMove:(UIPanGestureRecognizer*)PGR {
    CGPoint p = [PGR locationInView: self.superview];
    if(PGR.state==UIGestureRecognizerStateChanged){
        self.center = p;
    }
}

- (void)setMsgCount:(NSString*)msgCount{
    if (![self isPureInt:msgCount]) {
        return;
    }
    _msgCount = msgCount;
    if (msgCount.integerValue>9) {
        if (msgCount.integerValue>99) {
            self.msgLabel.text = @"99+";
        }else {
            self.msgLabel.text = msgCount;
        }
        if (self.frame.size.width!=ballDiameter99) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ballDiameter99);
                make.height.mas_equalTo(ballDiameter);
            }];
        }
    }else if(msgCount.integerValue==0){
        if (self.frame.size.width!=0) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(0);
            }];
        }
    }else {
        self.msgLabel.text = msgCount;
        if (self.frame.size.width!=ballDiameter) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ballDiameter);
                make.height.mas_equalTo(ballDiameter);
            }];
        }
    }
}

- (void)addMsgLabel{
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.msgLabel = label;
    
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont boldSystemFontOfSize:9];
    
    label.layer.cornerRadius = self.layer.cornerRadius;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
}

/// 网上扣的一个操作，用来判断NSString内部是不是int，经过检验发现即使传入的数Long，它也是返回YES
/// @param string 字符串
- (BOOL)isPureInt:(NSString*)string{

    NSScanner* scan = [NSScanner scannerWithString:string];

    int val;

    return[scan scanInt:&val] && [scan isAtEnd];

}
@end
