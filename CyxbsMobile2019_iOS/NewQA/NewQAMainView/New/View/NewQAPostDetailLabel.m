//
//  NewQAPostDetailLabel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/29.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAPostDetailLabel.h"

@implementation NewQAPostDetailLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
            _textInsets = UIEdgeInsetsZero;
        }
        return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:UIEdgeInsetsInsetRect(actualRect, _textInsets)];
}

@end
