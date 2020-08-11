//
//  CQUPTMapHotPlaceButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapHotPlaceButton.h"

@interface CQUPTMapHotPlaceButton ()

@property (nonatomic, weak) UIButton *hotButton;
@property (nonatomic, weak) UIImageView *hotTagImage;
@property (nonatomic, assign) CGFloat buttonWidth;

@end


@implementation CQUPTMapHotPlaceButton

- (instancetype)initWithTitle:(NSString *)title hotTag:(BOOL)isHot
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.buttonWidth = [self calculateTextWidth:title];
        
        UIButton *hotButton = [UIButton buttonWithType:UIButtonTypeSystem];
        hotButton.titleLabel.font = [UIFont fontWithName:PingFangSCHeavy size:15];
        if (@available(iOS 11.0, *)) {
            [hotButton setTitleColor:[UIColor colorNamed:@"Map_TextColor"] forState:UIControlStateNormal];
        } else {
            [hotButton setTitleColor:[UIColor colorWithHexString:@"#15305B"] forState:UIControlStateNormal];
        }
        [self addSubview:hotButton];
        self.hotButton = hotButton;
        
        if (isHot) {        // 后端返回字段判断为hot时才显示
            UIImageView *hotTagImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Map_HotTag"]];
            [self addSubview:hotTagImage];
            self.hotTagImage = hotTagImage;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.hotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(13);
        make.trailing.equalTo(self).offset(-13);
        make.height.equalTo(self);
        make.width.equalTo(@(self.buttonWidth));
    }];
    
    if (self.hotTagImage) {
        [self.hotTagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-3);
            make.top.equalTo(self).offset(3);
            make.height.equalTo(@12);
            make.width.equalTo(@22);
        }];
    }
}

- (CGFloat)calculateTextWidth:(NSString *)string {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCHeavy size:15]};

    CGRect rect = [string boundingRectWithSize:CGSizeMake(54, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.width;
}

@end
