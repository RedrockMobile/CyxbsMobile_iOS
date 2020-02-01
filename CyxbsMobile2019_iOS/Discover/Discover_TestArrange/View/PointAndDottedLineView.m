//
//  PointAndDottedLineView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PointAndDottedLineView.h"
#define color242_243_248toFFFFFF [UIColor colorNamed:@"color242_243_248&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface PointAndDottedLineView()
@property (nonatomic, assign) int pointCount;
@property (nonatomic) CGFloat spacing;
@property (nonatomic) CGFloat smallCircleRadius;
@property (nonatomic, strong)NSMutableArray<UIView*> *bigCircleArray;
@end
@implementation PointAndDottedLineView
- (instancetype)initWithPointCount:(int)pointCount Spacing:(CGFloat)spacing {
    if(self = [super init]) {
        self.pointCount = pointCount;
        self.spacing = spacing;
        [self addCircle];
        NSMutableArray *array = [NSMutableArray array];
        self.bigCircleArray = array;
        
    }
    return self;
}
- (void)addCircle {
    //大圆
    for(int i = 0 ; i < self.pointCount; i++) {
        UIView *bigCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 11, 11)];
        self.bigCircle = bigCircle;
        bigCircle.backgroundColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:209/255.0 alpha:1];
        bigCircle.layer.cornerRadius = bigCircle.size.width/2.0;
        [self addSubview:bigCircle];
        [self.bigCircleArray addObject:bigCircle];
//        if(i != 0) {
//            [bigCircle mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.bigCircleArray[0]);
//                make.top.equalTo(self.bigCircleArray[i-1].mas_bottom).offset(self.spacing - bigCircle.width);
//            }];
//        }
    }

    
    
    
    //小圆
    UIView *smallCircle = [[UIView alloc]init];
    self.smallCircle = smallCircle;
    smallCircle.backgroundColor = UIColor.clearColor;
    self.smallCircleRadius = 5;
    [self addSubview:smallCircle];

}
- (void)layoutSubviews {
//    [self.smallCircle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.bigCircle);
//        make.width.height.equalTo(@(self.smallCircleRadius));
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
