//
//  FinderTopView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "FinderTopView.h"

#pragma mark - FinderTopView ()

@interface FinderTopView ()

/// 显示日期或欢迎词
@property (nonatomic, strong) UILabel *detailLab;

/// “发现”
@property (nonatomic, strong) UILabel *titleLab;

/// 签到按钮
@property (nonatomic, strong) UIButton *signBtn;

/// 小圆球（因为需要在外界手动刷新，必须得property）
@property (nonatomic, strong) UIView *statusBall;

/// 消息按钮
@property (nonatomic, strong) UIButton *messageBtn;

/// 已读的Ball
@property (nonatomic, strong) UIView *readBall;

@end

#pragma mark - FinderTopView

@implementation FinderTopView

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        
        [self addSubview:self.detailLab];
        [self addSubview:self.titleLab];
        [self addSubview:self.signBtn];
        
//        self.msgVC = [[DiscoverMineMessageVC alloc] init];{
//            UIView *view = self.msgVC.view;
//            view.right = self.signBtn.left - 34;
//            view.top = self.signBtn.top;
//            
//            [self addSubview:view];
//        }
        
        [self reloadData];
    }
    return self;
}

#pragma mark - Method

- (void)addSignBtnTarget:(id)target action:(SEL)action {
    [self.signBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addMessageBtnTarget:(id)target action:(SEL)action {
    [self.messageBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)reloadData {
    switch ([NSUserDefaults.standardUserDefaults integerForKey:IS_TOKEN_URL_ERROR_INTEGER]) {
        case -1:
            self.statusBall.backgroundColor = UIColor.greenColor;
            break;
        case 1:
            self.statusBall.backgroundColor = UIColor.redColor;
            break;
        default:
            self.statusBall.backgroundColor = UIColor.yellowColor;
            break;
    }
}

#pragma mark - Getter

- (UILabel *)detailLab {
    if (_detailLab == nil) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(17, 1.7, 100, 13)];
        _detailLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _detailLab.font = [UIFont fontWithName:PingFangSCMedium size: 14];
        // about detail
        NSString *detailStr = [NSDate stringForSchoolWeek:
          ([NSDate.today timeIntervalSinceDate:
            [NSDate dateString:getDateStart_NSString
                 fromFormatter:NSDateFormatter.defaultFormatter
                withDateFormat:DateFormat]] / aWeekTimeInterval + 1)];
        // about week
        NSString *weekStr = [NSDate.today
                             stringFromFormatter:NSDateFormatter.ChineseFormatter
                             withDateFormat:@"EEE"];
        // about fastival
        NSString *fastivalStr = NSDate.today.stringForFastival;
        
        _detailLab.text = (detailStr ?
                           [NSString stringWithFormat:@"%@ %@ %@", detailStr, weekStr, fastivalStr] :
                           @"欢迎新同学～");
    }
    return _detailLab;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.detailLab.left, self.detailLab.bottom + 1, 200, 50)];
        _titleLab.text = @"发现";
        _titleLab.font = [UIFont fontWithName:PingFangSCSemibold size: 27];
        _titleLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _titleLab;
}

- (UIButton *)signBtn {
    if (_signBtn == nil) {
        _signBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _signBtn.right = self.SuperRight - 18;
        _signBtn.centerY = self.titleLab.centerY;
        _signBtn.contentMode = UIViewContentModeScaleToFill;
        _signBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [_signBtn setImage:[UIImage imageNamed:@"writeDiscover"] forState:UIControlStateNormal];
        
        [_signBtn addSubview:self.statusBall];
    }
    return _signBtn;
}

- (UIView *)statusBall {
    if (_statusBall == nil) {
        // 小红点 检测刷新token的接口是否有问题的代码
        _statusBall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        _statusBall.right = _signBtn.SuperRight;
        _statusBall.layer.cornerRadius = 1;
    }
    return _statusBall;
}

- (UIButton *)messageBtn {
    if (_messageBtn == nil) {
        _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.signBtn.top, 24, 24)];
        _messageBtn.right = self.signBtn.left - 10;
        _messageBtn.backgroundColor = UIColor.greenColor;
    }
    return _messageBtn;
}

- (UIView *)readBall {
    if (_readBall == nil) {
        _readBall = [[UIView alloc] initWithFrame:CGRectMake(self.signBtn.SuperRight + 2, -2, 4, 4)];
        _readBall.backgroundColor = UIColor.redColor;
        _readBall.layer.cornerRadius = _readBall.width / 2;
        _readBall.clipsToBounds = YES;
    }
    return _readBall;
}

#pragma mark - Setter

- (void)setHadRead:(BOOL)hadRead {
    if (_hadRead == hadRead) {
        return;
    }
    if (hadRead) {
        [self.messageBtn addSubview:self.readBall];
    } else {
        [self.readBall removeFromSuperview];
    }
}

@end
