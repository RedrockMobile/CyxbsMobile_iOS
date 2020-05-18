//
//  QAAskExitView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAExitView.h"

@implementation QAExitView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
    }
    [self setupView];
    return self;
}
- (void)setupView{
    self.backgroundView.layer.cornerRadius = 10;
    self.saveAndExitBtn.layer.cornerRadius = 17;
    self.continueEditBtn.layer.cornerRadius = 25;
}
@end
