//
//  QAAskNextStepView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskNextStepView.h"

@implementation QAAskNextStepView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.alpha = 1.0;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.27].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowRadius = 30;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 16;
    
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
