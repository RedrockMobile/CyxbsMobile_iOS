//
//  SegmentBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SegmentBarView.h"
#import "QASegementBarBtn.h"
#import "UIView+FrameTool.h"

@interface SegmentBarView ()
///分割条
@property (nonatomic, strong) UIView *topSeparation;

@property (nonatomic, strong) NSMutableArray *btnMuteAry;
@end
@implementation SegmentBarView
- (instancetype)initWithFrame:(CGRect)frame AndTextAry:(NSArray *)textAry{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        self.btnMuteAry = [NSMutableArray array];
        self.btnTextAry = textAry;
        [self creatAndConstriantBtn];
        [self addSubview:self.selectedImageView];
    }
    return self;
}


///创建并约束btn
- (void)creatAndConstriantBtn{
    if (self.btnTextAry.count == 0) {
        return;
    }
    //创建
    for (NSString *content in self.btnTextAry) {
        QASegementBarBtn *btn = [[QASegementBarBtn alloc] initWithFrame:CGRectZero AndContent:content];
        [self.btnMuteAry addObject:btn];
    }
    
    //约束btn的frame
    for (int i = 0; i < self.btnMuteAry.count; i++) {
        QASegementBarBtn *btn = self.btnMuteAry[i];
        
        [self addSubview:btn];
        
        if (i == 0) {
            btn.frame = CGRectMake(SCREEN_WIDTH * 0.112, 0, 36, 25);
        }else{
            QASegementBarBtn *lastBtn = self.btnMuteAry[i - 1];
            btn.frame = CGRectMake(lastBtn.maxX + 36, lastBtn.y, lastBtn.width, lastBtn.height);
        }
    }
}

#pragma mark -getter
- (UIImageView *)selectedImageView{
    if (!_selectedImageView) {
        QASegementBarBtn *btn = self.btnMuteAry[0];
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segemnSelecteSliderBar"]];
//        _selectedImageView.frame = CGRectMake(SCREEN_WIDTH * 0.112, 0, 36, 3);
        _selectedImageView.frame = CGRectMake(btn.x, btn.maxY + 6, 36, 3);
    }
    return _selectedImageView;
}

- (UIView *)topSeparation{
    if (_topSeparation == nil) {
        _topSeparation = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeparation.frame = CGRectMake(0, self.selectedImageView.maxY, SCREEN_WIDTH, 1);
//        _topSeparation.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#252525" alpha:1]];
        //设置阴影
        _topSeparation.layer.shadowColor = [UIColor colorWithRed:0.153 green:0.245 blue:0.383 alpha:0.08].CGColor;
    }
    return _topSeparation;
}

- (CGFloat)viewHeight{
    QASegementBarBtn *btn = self.btnMuteAry[0];
    _viewHeight =  btn.height + 3 + 1 + 6;
    return _viewHeight;
}
@end
