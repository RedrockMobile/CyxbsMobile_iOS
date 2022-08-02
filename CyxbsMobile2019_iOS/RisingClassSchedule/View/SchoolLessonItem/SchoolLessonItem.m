//
//  SchoolLessonItem.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolLessonItem.h"

NSString *SchoolLessonItemReuseIdentifier = @"SchoolLessonItem";

#pragma mark - SchoolLessonItem ()

@interface SchoolLessonItem ()

/// 课程名
@property (nonatomic, strong) UILabel *courseLab;

/// 上课地点
@property (nonatomic, strong) UILabel *classRoomLab;

/// 空课表时加号
@property (nonatomic, strong) UIImageView *addImgView;

/// 如果是多人的情况
@property (nonatomic, strong) UIView *multyView;

/// 背景图片
@property (nonatomic, strong) UIImageView *backgoundImgView;

@end

#pragma mark - SchoolLessonItem

@implementation SchoolLessonItem

#pragma mark - Lazy cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化的时候，一定要为一个假的数
        _draw = -1;
        
        self.contentView.layer.cornerRadius = 5;
        
        [self.contentView addSubview:self.backgoundImgView];
        [self.contentView addSubview:self.addImgView];
        [self.contentView addSubview:self.courseLab];
        [self.contentView addSubview:self.classRoomLab];
        [self.contentView addSubview:self.multyView];
    }
    return self;
}

#pragma mark - Method

- (void)drawRect:(CGRect)rect {
    [self.backgoundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.contentView);
    }];
    [self.courseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.top.equalTo(self.contentView).offset(8);
    }];
    [self.classRoomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.courseLab);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [self.addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(self.contentView.width - 2);
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - <SchoolClassTranslateData>

- (void)course:(NSString *)courseName classRoom:(NSString *)classRoom isMulty:(BOOL)isMulty {
    // 移除没必要的，和不确定的
    self.addImgView.alpha = 0;
    self.multyView.alpha = 0;
    // 添加现有的
    self.courseLab.alpha = 1;
    self.classRoomLab.alpha = 1;
    if (isMulty) {
        self.multyView.alpha = 1;
    }
    // 设置数据
    self.courseLab.text = courseName;
    self.classRoomLab.text = classRoom;
    
}

- (void)emptyWithAdd {
    // 移除其他的
    self.multyView.alpha = 0;
    self.courseLab.alpha = 0;
    self.classRoomLab.alpha = 0;
    
    // 添加现有的，如果本来就有，那就没必要了吧
    self.contentView.backgroundColor = UIColor.grayColor;
    if (self.contentView == self.addImgView.superview) {
        return;
    }
    self.addImgView.alpha = 1;
}

#pragma mark - Getter

- (UILabel *)courseLab {
    if (_courseLab == nil) {
        _courseLab = [[UILabel alloc] initWithFrame:CGRectMake(9, 7, 0, 42)];
        
        _courseLab.backgroundColor = UIColor.clearColor;
        _courseLab.numberOfLines = 3;
        _courseLab.textAlignment = NSTextAlignmentCenter;
        _courseLab.font = [UIFont fontWithName:PingFangSC size:10];
        
        [_courseLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _courseLab;
}

- (UILabel *)classRoomLab {
    if (_classRoomLab == nil) {
        _classRoomLab = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 0, 42)];
        
        _classRoomLab.backgroundColor = UIColor.clearColor;
        _classRoomLab.numberOfLines = 3;
        _classRoomLab.textAlignment = NSTextAlignmentCenter;
        _classRoomLab.font = [UIFont fontWithName:PingFangSC size:10];
        
        [_classRoomLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _classRoomLab;
}

- (UIImageView *)addImgView {
    if (_addImgView == nil) {
        _addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        // >>> 图片名字
        _addImgView.image = [UIImage imageNamed:@"setting"];
    }
    return _addImgView;
}

- (UIView *)multyView {
    if (_multyView == nil) {
        _multyView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 8, 2)];
        _multyView.right = self.contentView.SuperRight - 5;
        
        _multyView.layer.cornerRadius = _multyView.height / 2;
    }
    return _multyView;
}

- (UIImageView *)backgoundImgView {
    if (_backgoundImgView == nil) {
        _backgoundImgView = [[UIImageView alloc] init];
        
        _backgoundImgView.image = [UIImage imageNamed:@"default_background"];
    }
    return _backgoundImgView;
}

#pragma mark - Setter

- (void)setDraw:(ClassBookItemDraw)draw {
    if (draw == _draw) {
        return;
    }
    self.backgoundImgView.alpha = 0;
    _draw = draw;
    // 这个方法只对颜色进行改变
    switch (draw) {
        case ClassBookItemDrawMorning: {
            // 对应橙色
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F9E7D8" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#FFCCA1" alpha:0.15]];
            
            self.courseLab.textColor = self.classRoomLab.textColor = self.multyView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FF8015" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.8]];
        } break;
            
        case ClassBookItemDrawAfternoon: {
            // 对应粉色
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F9E3E4" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#FF979B" alpha:0.15]];
            
            self.courseLab.textColor = self.classRoomLab.textColor = self.multyView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FF6262" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.8]];
        } break;
            
        case ClassBookItemDrawNight: {
            // 对应紫色
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#DDE3F8" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#9BB2FB" alpha:0.15]];
            
            self.courseLab.textColor = self.classRoomLab.textColor = self.multyView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#4066EA" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.8]];
        } break;
            
        case ClassBookItemDrawMulty: {
            // 对应青色
            self.contentView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#DFF3FC" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#90DBFB" alpha:0.15]];
            
            self.courseLab.textColor = self.classRoomLab.textColor = self.multyView.backgroundColor =
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#06A3FC" alpha:1]
                                  darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.8]];
        } break;
            
        case ClassBookItemDrawCustom: {
            // 自定义灰
            self.contentView.backgroundColor = UIColor.grayColor;
            
            self.courseLab.textColor = self.classRoomLab.textColor = self.multyView.backgroundColor =
            [UIColor dm_colorWithLightColor:UIColor.blackColor
                                  darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.8]];
            
            self.backgoundImgView.alpha = 1;
        } break;
    }
}

@end
