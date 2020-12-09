//
//  MGDSliderBarItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MGDSliderBarItem.h"

#define DEFAULT_TITLE_FONTSIZE 18
#define DEFAULT_TITLE_COLOR [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]
#define HORIZONTAL_MARGIN 10

@interface MGDSliderBarItem()
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *color;

@end

@implementation MGDSliderBarItem

- (instancetype) init {
    if (self = [super init]) {
        _fontSize = DEFAULT_TITLE_FONTSIZE;
        if (@available(iOS 11.0, *)) {
            _color = [UIColor colorNamed:@"MGDLoginTitleColor"];
            self.backgroundColor = [UIColor clearColor];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat titleX = (CGRectGetWidth(self.frame) - [self titleSize].width) * 0.5;
    CGFloat titleY = (CGRectGetHeight(self.frame) - [self titleSize].height) * 0.5;
    
    CGRect titleRect = CGRectMake(titleX, titleY, [self titleSize].width, [self titleSize].height);
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:_fontSize], NSForegroundColorAttributeName : _color};
    [_title drawInRect:titleRect withAttributes:attributes];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setItemTitle:(NSString *)title {
    _title = title;
    [self setNeedsDisplay];
}

- (void)setItemTitleFont:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemTitleColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}


- (CGSize)titleSize {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:_fontSize]};
    CGSize size = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

+ (CGFloat)widthForTitle:(NSString *)title {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:DEFAULT_TITLE_FONTSIZE]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2;
    return size.width;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderBarItemSelected:)]) {
        [self.delegate sliderBarItemSelected:self];
    }
}



@end
