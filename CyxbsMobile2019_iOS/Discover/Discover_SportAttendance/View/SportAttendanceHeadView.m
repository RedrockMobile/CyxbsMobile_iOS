//
//  SportAttendanceHeadView.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SportAttendanceHeadView.h"

@interface SportAttendanceHeadView()

///
/// 总计
@property (nonatomic, strong) UILabel *totLab;

/// 跑步
@property (nonatomic, strong) UILabel *runLab;

/// 其他
@property (nonatomic, strong) UILabel *othLab;

/// 奖励
@property (nonatomic, strong) UILabel *awaLab;

@end

@implementation SportAttendanceHeadView

#pragma mark - Init

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImg = [[UIImageView alloc] initWithFrame:self.frame];
        backImg.image = [UIImage imageNamed:@"Image"];
        [self addSubview:backImg];
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        [self addSubview:self.totLab];
        [self addSubview:self.runLab];
        [self addSubview:self.othLab];
        [self addSubview:self.awaLab];
    }
    return self;
}

#pragma mark - Getter

- (UILabel *)totLab{
    if (!_totLab) {
        _totLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    }
    return _totLab;
}

- (UILabel *)runLab{
    if (!_runLab) {
        _runLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 30)];
        _totLab.text = @"总计:NULL";
    }
    return _runLab;
}

- (UILabel *)othLab{
    if (!_othLab) {
        _othLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 100, 30)];
        _othLab.text = @"跑步:NULL";
    }
    return _othLab;
}

- (UILabel *)awaLab{
    if (!_awaLab) {
        _awaLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 100, 30)];
        _awaLab.text = @"奖励:NULL";
    }
    return _awaLab;
}

- (void)loadViewWithDate:(SportAttendanceModel *)sAData{
    self.totLab.text = [NSString stringWithFormat:@"总计:%ld/%ld", sAData.run_done + sAData.other_done, sAData.run_total + sAData.other_total];
    self.runLab.text = [NSString stringWithFormat:@"跑步:%ld/%ld", sAData.run_done, sAData.run_total];
    self.othLab.text = [NSString stringWithFormat:@"其他:%ld/%ld", sAData.other_done, sAData.other_total];
    self.awaLab.text = [NSString stringWithFormat:@"奖励:%ld",sAData.award];
}
@end
