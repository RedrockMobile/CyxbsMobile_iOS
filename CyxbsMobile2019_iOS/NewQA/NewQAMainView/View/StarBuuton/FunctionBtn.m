//
//  FunctionBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "FunctionBtn.h"
@interface FunctionBtn()
@property(nonatomic, strong)MGDClickLayer *clickLayer;
@property(nonatomic, strong)MGDCircleLayer *circleLayer;
@end

@implementation FunctionBtn

- (instancetype) init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:@"Arial" size: 12];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_countLabel];
        _isFirst = YES;
        [self initLayers];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0547);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_top).mas_offset(SCREEN_HEIGHT * 0.009);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.052 * 8.5/19.5);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(SCREEN_WIDTH * 0.0173);
    }];
    self.clickLayer.frame = self.iconView.bounds;
    self.shineLayer.frame = self.iconView.bounds;
}

- (void)setIconViewSelectedImage:(UIImage *)selectedImage AndUnSelectedImage:(UIImage *)unSelectedImnage {
    if (self.selected == YES) {
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = selectedImage;
    }else {
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = unSelectedImnage;
    }
}

#pragma mark -按钮特效的设置
-(MGDClickLayer *)clickLayer {
    if (_clickLayer == nil) {
        _clickLayer = [[MGDClickLayer alloc]init];
    }
    return _clickLayer;
}

-(MGDCircleLayer *)shineLayer {
    if (_circleLayer == nil) {
        _circleLayer = [[MGDCircleLayer alloc]init];
    }
    return _circleLayer;
}

-(void)setParams:(MGDClickParams *)params {
    _params = params;
    self.clickLayer.animationDuration = _params.animationDuration / 3;
    self.shineLayer.params = _params;
}


-(void)initLayers {
    self.clickLayer.animationDuration = self.params.animationDuration / 3;
    self.shineLayer.params = self.params;
    [self.layer addSublayer:self.clickLayer];
    [self.layer addSublayer:self.shineLayer];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    __weak typeof(self) weakSelf = self;
    if (self.clickLayer.clicked == false) {
        self.shineLayer.endAnim = ^{
            if (weakSelf.clickLayer.clicked == false) {

            }else{
                weakSelf.clickLayer.clicked = !weakSelf.clickLayer.clicked;
            }
        };
        if (weakSelf.isFirst == NO && weakSelf.selected == YES) {
            [self.shineLayer startAnimation];
        }
    }else{
        self.clickLayer.clicked = !weakSelf.clickLayer.clicked;
        self.isChoose = !weakSelf.isChoose;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
