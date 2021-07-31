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
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
